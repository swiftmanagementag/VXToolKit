//
//  VXImport.m
//  
//
//  Created by Graham Lancashire on 18.08.11.
//  Copyright 2011 Swift Management AG. All rights reserved.
//

#import "VXImport.h"
#import <Foundation/Foundation.h>
#import "NSManagedObject+Category.h"

#import "VXImportParser.h"
#import "VXConfiguration.h"

@implementation VXImport

+ (instancetype)sharedInstance {
	static id _sharedInstance = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_sharedInstance = [[[self class] alloc] init];
	});
	
	return _sharedInstance;
}

- (instancetype) init{
	if (self = [super init]) {
		self.isLowerCaseFileName = false;
	}
    return self;
}

// indicates if the database needs to be updated
- (BOOL)isImportNecessary {
    return YES;
    /*
    // get the application version
	NSString *versionApp = [VXConfiguration getVersion];
	
	// get current db version 
	Version *version = [Version getVersionCurrent];
	
    // Check the current version
    if( version == nil ) {
        // if the current version is nil
        DebugLog( @"Version app:%@ db:nil - full import", versionApp);
        return YES;
    } else if (![[version isImported] boolValue] || ![[version code] isEqualToString:versionApp] ) {
#ifdef DEBUG_MODE
        // in debug mode only consider the first 3 letters
        if([versionApp length] > 6 && [[version code] length] > 6 && [[[version code] substringToIndex:6] isEqualToString:[versionApp substringToIndex:6 ]]) {
            DebugLog( @"Version app:%@ db:%@ %i - import not necessary (debug)", versionApp, version.code, [[version isImported] boolValue]);
            return NO;
        }
#endif
        // if the current version is not imported or the versions do not match
        DebugLog( @"Version app:%@ db:%@ %i - import", versionApp, version.code, [[version isImported] boolValue]);
        return YES;
    } else {
        DebugLog( @"Version app:%@ db:%@ %i - no import needed", versionApp, version.code, [[version isImported] boolValue]);
        return NO;
    }
	 */
}

- (BOOL)isInitialLoad {
    // Check if we have an initial load
	BOOL isInitialLoad = YES; //[Version isInitial];
#if DEBUG && TARGET_IPHONE_SIMULATOR
    isInitialLoad = YES;
#endif
	return isInitialLoad;
}
// perform the import
- (void)import {
	NSString *versionApp = [VXConfiguration getVersion];
//	Version *version = [Version getVersionCurrent];
	
    // Check if we have an initial load
	BOOL isInitialLoad = [self isInitialLoad];
    if(isInitialLoad) {
        NSLog( @"Performing initial import");
        [self importWithVersion:@""];
    } else {
        NSLog( @"Performing short import");
        [self importWithVersion:versionApp];
    }
    
//    if(version != nil) {
  //      // mark current version as old
    //    [version setStatus:@1];
    //}
    
   // Version *versionNew = [Version getVersion:versionApp];
	
//    if(versionNew != nil) {
  //      // mark new version as current
    //    [versionNew setStatus:@0];
	//	[versionNew setIsImported:@YES ];
    //}
    [self saveWithIsFinished:YES];
}
- (void)importWithVersion:(NSString *)pVersion {
    // Get Files to import
    NSArray *files = [self getFiles];
    
    // Import files
    for(NSString *file in files) {
        // this needs to be done for all versions
        NSLog( @"* Importing %@ %@", file, pVersion);
        if([self importFile:self.isLowerCaseFileName == YES ? [file lowercaseString] : file withVersion:pVersion]) {
        }
	}
    [self saveWithIsFinished:NO];
}
- (BOOL)importFile:(NSString *)pFile withVersion:(NSString*)pVersion{
	BOOL isImported = NO;
	
	[self setCurrentFile:pFile];
	
	// set up file access
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
    NSString *paths = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath;
	
    if([pVersion length] > 0) {
        // Only use the first there letter of the version 1.5 oder 2.5
		bundlePath = [paths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@.csv",pFile, [pVersion substringToIndex:3 ]]];
    } else {
		bundlePath = [paths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv",pFile ]];
    }
    
    // check if the file was found
    if ([fileManager fileExistsAtPath:bundlePath]) {
		// load data file
		NSString *dataFile = [[NSString alloc] initWithContentsOfFile:bundlePath  encoding:NSUTF8StringEncoding error:nil];
        
        #ifdef DEBUG_MODE
        NSDate *startDate = [NSDate date];
        #endif
        
		NSArray *arrFields  = [self getFieldNames:pFile];
        if(arrFields != nil) {
            VXImportParser *parser = [[VXImportParser alloc] initWithString:dataFile separator:@"|" hasHeader:NO fieldNames:arrFields];
            
            [parser parseRowsForReceiver:self selector:@selector(receiveRecord:)];
          
            #ifdef DEBUG_MODE
            NSDate *endDate = [NSDate date];
            DebugLog(@"%@ entries successfully imported in %f seconds.", pFile, [endDate timeIntervalSinceDate:startDate]);
            #endif
        }
        
		[self saveWithIsFinished:NO];
		
        isImported = YES;
	}
	return isImported;	
}

- (NSArray* )getFiles { 
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSArray* )getFieldNames:(NSString *)pFile {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)receiveRecord:(NSDictionary *)pRecord {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)save {
    [self saveWithIsFinished:YES];
}

- (void)saveWithIsFinished:(BOOL)pIsFinished {
    [self doesNotRecognizeSelector:_cmd];
}


@end
