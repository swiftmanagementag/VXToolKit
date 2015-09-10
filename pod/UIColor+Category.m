//
//  UIColor+Category.m
//  iTheorie
//
//  Created by Graham Lancashire on 25.10.12.
//  Copyright (c) 2012 Swift Management AG. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)
+ (UIColor *)colorWithHueDegrees:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness {
    return [UIColor colorWithHue:(hue/360) saturation:saturation brightness:brightness alpha:1.0];
}
+ (UIColor *) colorWithHexValue:(uint) hex {
	return [UIColor colorWithHexValue:hex andAlpha:1.0f];
}
+ (UIColor *)colorWithHexValue:(uint)hex andAlpha:(float)pAlpha;
{
	int red, green, blue, alpha;
	blue = hex & 0x000000FF;
	green = ((hex & 0x0000FF00) >> 8);
	red = ((hex & 0x00FF0000) >> 16);
	alpha = ((hex & 0xFF000000) >> 24);
	if (alpha == 0.0f) {
		alpha = pAlpha;
	}
	return [UIColor colorWithRed:red/255.0f
						   green:green/255.0f
							blue:blue/255.0f
						   alpha:alpha/255.0f];
}
+ (UIColor*)colorWithHexString:(NSString*)hexValue {
	return [UIColor colorWithHexString:hexValue andAlpha:1.0f];
}
+ (UIColor*)colorWithHexString:(NSString*)hexValue andAlpha:(float)alpha ;
{
    UIColor *defaultResult = [UIColor blackColor];
    
    // Strip leading # if there is one
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [hexValue substringFromIndex:1];
    }
    
    NSUInteger componentLength = 0;
    if ([hexValue length] == 3)
        componentLength = 1;
    else if ([hexValue length] == 6)
        componentLength = 2;
    else
        return defaultResult;
    
    BOOL isValid = YES;
    CGFloat components[3];
    
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 256.0;
    }
	
    if (!isValid) {
        return defaultResult;
    }
    
    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:1.0];
}
- (NSString *) hexStringFromColor{
	CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
	// iOS 5
	if ( [self respondsToSelector: @selector(getRed:green:blue:alpha:)] ) {
		[self getRed: &red green: &green blue: &blue alpha: &alpha];
	}
	else {
		const CGFloat *components = CGColorGetComponents( [self CGColor] );
		red = components[0];
		green = components[1];
		blue = components[2];
		alpha = components[3];
	}
	return [NSString stringWithFormat: @"#%02lX%02lX%02lX",
			(long) roundf( red * 255.0 ),
			(long) roundf( green * 255.0 ),
			(long) roundf( blue * 255.0 )];
}
+ (UIColor *)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
	return [UIColor colorWithRed:(float)red/255.0 green:(float)green/255.0 blue:(float)blue/255.0 alpha:1.0f];
}


@end
