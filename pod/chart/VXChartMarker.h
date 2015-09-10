//
//  VXChartMarker.h
//  iTheorie
//
//  Created by Graham Lancashire on 24.02.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VXChartMarkerType) {
	kMarkerX = 0,
	kMarkerY = 1,
	kMarkerXY = 2
} ;

@class VXChartView;


@interface VXChartMarker : UIView {}


@property (nonatomic, assign) int index;
@property (nonatomic, assign) VXChartMarkerType type;
@property (nonatomic, strong) IBOutlet NSString *title;

@property (nonatomic, strong) VXChartView *chart;

@property (nonatomic, assign) double lineSize;

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIFont *font;


@end
