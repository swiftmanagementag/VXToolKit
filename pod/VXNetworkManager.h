//
//  VXNetworkManager.h
//  iTheorie
//
//  Created by Graham Lancashire on 25.10.12.
//  Copyright (c) 2012 Swift Management AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface VXNetworkManager : NSObject
@property (nonatomic, strong) Reachability* reachability;
@property BOOL isConnected;

+ (VXNetworkManager *)sharedInstance;
- (void)start;

@end
