//
//  VXDataManager.h
//  Core Data Manager
//
#import <CoreData/CoreData.h>

@interface VXDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSManagedObjectContext *backgroundContext;
@property (strong, nonatomic) NSManagedObjectModel *model;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStore;

@property (strong, nonatomic) NSString *databaseName;

+ (VXDataManager *)sharedInstance;
- (VXDataManager *)init NS_DESIGNATED_INITIALIZER;
- (BOOL)copyStoreWithOverwrite:(BOOL)pOverwriteExisting;
@property (NS_NONATOMIC_IOSONLY, getter=isMigrationNecessary, readonly) BOOL migrationNecessary;
- (void)save;
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSURL *storeURL;
@end
