//
//  VXConfiguration.h
//  
//
//  Created by Graham Lancashire on 25.10.12.
//
//

#import "VXConfiguration.h"

@implementation VXConfiguration
+ (NSString *)getVersionShort {
	NSArray *versionComponents = [[self getVersion] componentsSeparatedByString:@"."];
	NSString *appVersion;
	
	if ([versionComponents count] > 1) {
		appVersion = [NSString stringWithFormat:@"%@.%@", versionComponents[0], versionComponents[1], nil ];
	} else {
		appVersion = @"";
	}
	
	return appVersion;
}


+ (NSString *)getVersion {
	NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
	return appVersion;
}

+ (NSString *) getNib:(NSString *)pNib {
    if(pNib == nil){
        return nil;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [NSString stringWithFormat:@"%@-iPad", pNib];
    } else {
        return pNib;
    }
}

@end
