//
//  SKProduct+LocalizedPrice.h
//  iTheorie
//
//  Created by Graham Lancashire on 14.10.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end