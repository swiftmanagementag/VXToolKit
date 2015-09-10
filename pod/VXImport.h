//
//  VXImport.h
//  
//
//  Created by Graham Lancashire on 18.08.11.
//  Copyright 2011 Swift Management AG. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



@interface VXImport : NSObject {}

@property (NS_NONATOMIC_IOSONLY, getter=isImportNecessary, readonly) BOOL importNecessary ;
@property (NS_NONATOMIC_IOSONLY, getter=isInitialLoad, readonly) BOOL initialLoad;
@property (NS_NONATOMIC_IOSONLY, getter=getFiles, readonly, copy) NSArray *files;
@property (nonatomic, strong) NSString *currentFile;
@property (nonatomic) BOOL isLowerCaseFileName;

+ (instancetype)sharedInstance;

- (instancetype) init NS_DESIGNATED_INITIALIZER;

- (void)import ;
- (void)importWithVersion:(NSString *)pVersion;
- (BOOL)importFile:(NSString *)pFile withVersion:(NSString*)pVersion;

- (void)save;
- (NSArray* )getFieldNames:(NSString *)pType;
- (void)receiveRecord:(NSDictionary *)pRecord;



@end
