//
//  VXBardCell.h
//  iTheorie
//
//  Created by Graham Lancashire on 28.01.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface VXBarItem : NSObject {}

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *text;
@property double value;

@end

@interface VXBarView : UIView {
	CGSize textSize;
}

@property NSInteger width;
@property (nonatomic,strong) UITableViewCell *parent;
@property (nonatomic,strong) UIFont *font;
@property (nonatomic, strong) NSString *barText;
@property (nonatomic, strong) UIColor *barTextColor;
@property (nonatomic, strong) NSMutableArray* items;   	
@property (nonatomic, strong) UIColor *borderColor;
@property double borderWidth;

@property double barAlpha;
@property double barGradientEffect;

@property (NS_NONATOMIC_IOSONLY, getter=getTotal, readonly) double total ;

@end

@interface VXBarCell : UITableViewCell {}

@property (nonatomic, strong) VXBarView *bar;
@property (nonatomic, strong) UIColor *barTextColor;

@property (nonatomic, strong) NSMutableArray* items;   	
@property (nonatomic, strong) UIColor *borderColor;
@property double borderWidth;
@property double cornerRadius;

@property double barAlpha;
@property double barGradientEffect;

@end
