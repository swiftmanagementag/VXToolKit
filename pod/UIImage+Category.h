//
//  UIImage+Rotate.h
//  iTheorie
//
//  Created by Graham Lancashire on 11.08.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIImage (Category)

-(UIImage*)rotate:(UIImageOrientation)orient;
+(NSString *)resolutionIndependentImagePath:(NSString *)path;
+(NSString *)resolutionIndependentImagePath:(NSString *)path withForce:(BOOL)pForce;
+ (UIImage *)convertImageToGrayScale:(UIImage *)image;
+ (UIImage *)convertImageToNegative:(UIImage *)image;

@property (NS_NONATOMIC_IOSONLY, readonly, strong) UIImage *convertToGreyscale;

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;;
- (UIImage*) overlay:(UIImage*)pOverlay;
+ (UIImage*)load:(NSString*)pName;
- (void)saveAs:(NSString*)pName;
+(UIImage *) image:(UIImage *)img withColor:(UIColor *)color;
- (UIImage *) tintImageWithColor: (UIColor *) color;

@end
