//
//  UIFont+Category.m
//  iTheorie
//
//  Created by Graham Lancashire on 24.10.12.
//  Copyright (c) 2012 Swift Management AG. All rights reserved.
//

#import "UIFont+Category.h"
#import "iTheorieAppDelegate.h"

@implementation UIFont (Category)

+ (UIFont *)defaultFontOfSize:(CGFloat)pFontSize {
    return [UIFont fontWithName:kFont size:pFontSize];
}
+ (UIFont *)boldDefaultFontOfSize:(CGFloat)pFontSize {
    return [UIFont fontWithName:kFontBold size:pFontSize];
}
@end