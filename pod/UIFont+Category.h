//
//  UIFont+Category.h
//  iTheorie
//
//  Created by Graham Lancashire on 24.10.12.
//  Copyright (c) 2012 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFont @"TrebuchetMS"
#define kFontBold @"TrebuchetMS-Bold"

// smallSystemFontSize	 12
// systemFontSize	 14
// labelFontSize	 17
// buttonFontSize	 18

@interface UIFont (Category)
+ (UIFont *)defaultFontOfSize:(CGFloat)pFontSize;
+ (UIFont *)boldDefaultFontOfSize:(CGFloat)pFontSize;

@end
