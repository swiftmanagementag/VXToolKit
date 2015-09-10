//
//  UIColor+Category.h
//  iTheorie
//
//  Created by Graham Lancashire on 25.10.12.
//  Copyright (c) 2012 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef RGB
#define RGB(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#endif

@interface UIColor (Category)
+ (UIColor *)colorWithHueDegrees:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness ;
+ (UIColor *)colorWithHexValue:(uint) hex;
+ (UIColor*)colorWithHexString:(NSString*)hexValue;
+ (UIColor *)colorWithHexValue:(uint)hex andAlpha:(float)alpha;
+ (UIColor*)colorWithHexString:(NSString*)hexValue andAlpha:(float)alpha ;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *hexStringFromColor;
+ (UIColor *)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;


@end
