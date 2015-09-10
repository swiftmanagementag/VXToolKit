//
//  VXChartAxis.h
//  iTheorie
//
//  Created by Graham Lancashire on 04.02.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VXChartView;


typedef NS_ENUM(NSInteger, VXChartAxisType) {
	kAxisX = 0,
	kAxisY = 1
} ;


@interface VXChartAxis : UIView {}

@property (nonatomic, assign) VXChartAxisType type;
@property (nonatomic, strong) IBOutlet NSFormatter *valuesFormatter;
@property (nonatomic, strong) IBOutlet NSString *title;
@property (nonatomic, strong) VXChartView *chart;

@property (nonatomic, assign) BOOL drawAxis;
@property (nonatomic, assign) BOOL drawGrid;

@property (nonatomic, assign) double dimension;

@property (nonatomic, strong) UIColor *valuesColor;
@property (nonatomic, strong) UIColor *gridColor;
@property (nonatomic, strong) UIFont *font;

@property NSInteger tickSkip;
@property NSInteger tickCount;

@property double max;
@property double maxManual;

@property double min;
@property double minManual;
@property (NS_NONATOMIC_IOSONLY, readonly) double factor;
@property (NS_NONATOMIC_IOSONLY, readonly) double tick;

- (void)reset;
@end