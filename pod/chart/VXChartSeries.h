//
//  VXChartSeries.h
//  iTheorie
//
//  Created by Graham Lancashire on 05.02.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VXChartView;

@interface VXChartSeries : UIView {}

@property (nonatomic, assign) int index;
@property (nonatomic, strong) IBOutlet NSString *title;

@property (nonatomic, strong) VXChartView *chart;

@property (nonatomic, assign) double lineSize;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *borderColor;
@property double borderWidth;

@end
