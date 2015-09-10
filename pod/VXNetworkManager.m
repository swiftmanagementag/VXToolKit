//
//  VXNetworkManager.m
//  iTheorie
//
//  Created by Graham Lancashire on 25.10.12.
//  Copyright (c) 2012 Swift Management AG. All rights reserved.
//

#import "VXNetworkManager.h"

static VXNetworkManager *sharedMyManager = nil;

@implementation VXNetworkManager


#pragma mark - Singleton & init

+ (VXNetworkManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedMyManager == nil) {
            sharedMyManager = [[self alloc] init];
        }
    });
    return sharedMyManager;
}
- (instancetype)init {
	if (self = [super init]) {
		self.isConnected = FALSE;
		
		self.reachability  = [Reachability reachabilityWithHostname:@"www.google.com"];
		
		// this is to avoid warnings
		__unsafe_unretained VXNetworkManager* me = self;
		// set the blocks
		self.reachability.reachableBlock = ^(Reachability*reach) {
			NSLog(@"REACHABLE!");
			me.isConnected = YES;
		};
		
		self.reachability.unreachableBlock = ^(Reachability*reach) {
			NSLog(@"UNREACHABLE!");
			me.isConnected = NO;
		};
		
		// start the notifier which will cause the reachability object to retain itself!
		[self.reachability startNotifier];
	}
	
	return self;
}
- (void)start {
	// do nothing
}
- (BOOL)isNetworkReachable {
    return ([self.reachability currentReachabilityStatus] != NotReachable);
}

@end

