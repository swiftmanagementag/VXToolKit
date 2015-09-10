//
//  VXDataManager.m
//  Core Data Manager
//

#import "VXDataManager.h"
#include <sys/xattr.h>

static VXDataManager *sharedMyManager = nil;

@implementation VXDataManager

#pragma mark - Singleton & init

+ (VXDataManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedMyManager == nil) {
            sharedMyManager = [[self alloc] init];
        }
    });
    return sharedMyManager;
}

- (VXDataManager *)init {
    if (self = [super init]) {
#if defined(CUSTOM_DATABASE_NAME)
		self.databaseName = CUSTOM_DATABASE_NAME;
#else
        self.databaseName = [self appName];
#endif
    }
    return self;
}

- (NSString *)appName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)backgroundContext {
	if(IS_IOS7_AND_UP) {
		if (_backgroundContext != nil) {
			return _backgroundContext;
		}
		_backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		_backgroundContext.parentContext = self.context;
		return _backgroundContext;
	} else {
		return self.context;
	}
}
- (NSManagedObjectContext *)context {
    if (_context != nil) {
        return _context;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStore];
    if (coordinator != nil) {
		if(IS_IOS7_AND_UP) {
			_context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
			[_context setUndoManager:nil];
		} else {
			_context = [[NSManagedObjectContext alloc] init];
		}
        [_context setPersistentStoreCoordinator:coordinator];
        [_context setStalenessInterval:0];
    }
    return _context;
}
- (NSURL*)storeURL {
	NSString *applicationDirectory = [self documentsDirectory];
	NSString *databaseName  = [NSString stringWithFormat:@"%@.sqlite", self.databaseName];
	NSURL * url =[[NSURL fileURLWithPath:applicationDirectory] URLByAppendingPathComponent:databaseName];
	return url;
}

- (NSPersistentStoreCoordinator *)persistentStore {
    if (_persistentStore != nil) {
        return _persistentStore;
    }
    NSURL *storeURL = [self storeURL];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                             NSInferMappingModelAutomaticallyOption: @YES};
    _persistentStore = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    
    NSError *error = nil;
    if (![_persistentStore addPersistentStoreWithType:NSSQLiteStoreType configuration:nil 
                                                   URL:storeURL options:options error:&error]) {
        /*
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         */
        NSLog(@"VXDataManager addPersistentStoreWithType: %@", error);
    }
    return _persistentStore;
}

- (NSManagedObjectModel *)model {
    if (_model != nil) {
        return _model;
    }
#if defined(CUSTOM_MODEL_NAME)
	// Handle situation if there is a preexisting mom file causing errors
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSString *modelPath = [[NSBundle mainBundle] pathForResource:CUSTOM_MODEL_NAME ofType:@"momd"];
	if(![fileManager fileExistsAtPath:modelPath]) {
		modelPath = [[NSBundle mainBundle] pathForResource:CUSTOM_MODEL_NAME ofType:@"mom"];
	}
		
	NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
	_model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	
	if (_model != nil) {
        return _model;
    }
#endif
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _model;
}

- (NSString *)documentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	return [paths lastObject];
}
- (BOOL)isMigrationNecessary{
    NSURL *storeUrl = [self storeURL];
    
    NSError *error = nil;
    
    // Initialise a coordinator with the current model
    NSPersistentStoreCoordinator *pscCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self model]];
    
    // Determine if a migration is needed
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeUrl error:&error];
    
    // Assume compatible
    BOOL isCompatible = YES;
    
    // Check compatability if there is source metadata
    if(sourceMetadata) {
        NSManagedObjectModel *destinationModel = [pscCoordinator managedObjectModel];
        
        isCompatible = [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    }
    NSLog(@"Migration needed? %d", !isCompatible);
    return !isCompatible;
}

- (BOOL)copyStoreWithOverwrite:(BOOL)pOverwriteExisting {
    BOOL isCopied =NO;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *storePath = [[self documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.databaseName]];
    NSString *defaultStorePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.databaseName]];
    
    
	NSError *error;
	
    // Delete existing database if overwrite is specified
    if(pOverwriteExisting) {
        if ([fileManager fileExistsAtPath:storePath]) {
            if(![fileManager removeItemAtPath:storePath error:&error]) {
				DebugLog(@"Failed to create writable database file with message '%@'.",   [error localizedDescription]);
			}
        }
    }
    
    // if there is no database and we have a default path
    if (![fileManager fileExistsAtPath:storePath] && defaultStorePath) {
        // Overwrite with default DB
        if (![fileManager copyItemAtPath:defaultStorePath toPath:storePath error:&error]) {
			DebugLog(@"Failed to create writable database file with message '%@'.",   [error localizedDescription]);
		}
        
        isCopied =YES;
    }
    long long fileSize = [[fileManager attributesOfItemAtPath:storePath error:nil][NSFileSize] longLongValue];
    if(fileSize > 2000000) {
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        [self addSkipBackupAttributeToItemAtURL:storeUrl];
    }
    return isCopied;
    
}
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    NSInteger result = -1;

    @try {
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    } @catch (NSException * e) {
        DebugLog(@"Exception: %@", e);
    }
    return result == 0;
}
- (void)save {
    NSError *error = nil;
	
	if(IS_IOS7_AND_UP) {
		if ((_backgroundContext != nil) && _backgroundContext.hasChanges) {
			[_backgroundContext save:&error];
		}
	}
    if ((self.context != nil) && self.context.hasChanges) {
		if(IS_IOS7_AND_UP) {
			[self.context performBlock:^{
				NSError *parentError = nil;
				if ([self.context save:&parentError]) {
					NSLog(@"VXDataManager context save.");
				} else {
					NSLog(@"VXDataManager context save failed: %@", parentError);
					abort();
				};
			}];
		} else {
			if ([self.context save:&error]) {
				NSLog(@"VXDataManager context save.");
			} else {
				NSLog(@"VXDataManager context save failed: %@", error);
				abort();
			}
        }
    }
}
@end
