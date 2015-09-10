//
//  VXChartAxis.m
//  iTheorie
//
//  Created by Graham Lancashire on 04.02.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import "VXChartAxis.h"
#import "VXChartView.h"
#import "VXConfiguration.h"
#import "UIFont+Category.h"

@interface VXChartAxis (PrivateMethods)

- (void)initializeComponent;

@end


@implementation VXChartAxis

// this has to stay

@synthesize max = _max, maxManual = _maxManual;
@synthesize min = _min, minManual = _minManual;
@synthesize tickCount = _tickCount;
// make sure the initialisation is called
-(instancetype)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
		[self initializeComponent];
    }
	
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
	
	if ((self = [super initWithCoder:decoder])) {
		[self initializeComponent];
	}
	
	return self;
}
#pragma mark PrivateMethods

- (void)initializeComponent {
	//DebugLog(@"Initialising Axis %li", [self type]);
	
	// Setting default values
	_min = DBL_MAX;
	_max = DBL_MIN;
	
	_drawAxis = YES;
	_drawGrid = YES;
	
	_valuesColor = [UIColor blackColor];
	
	_gridColor = [UIColor lightGrayColor];
	
	_font = [UIFont defaultFontOfSize:kVXTableFontSmallSize];
	_title = @"";
	
	_tickCount = 5;
	_tickSkip = 0;
}
#pragma mark PrivateMethods End

// axis is still drawn in the graph
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

// get the extreme values
- (double)getExtreme:(BOOL)isMax withValue:(double)pValue {
	double extreme;
	
	// if are looking for the maximum initialize with the lowest float, vice versa
	extreme = pValue;
	
	// get the number of Plots
	NSUInteger numberOfSeries = [self.chart.dataSource numberOfSeries:self.chart];
	
	// loop through the Plots
	for (NSUInteger seriesIndex = 0; seriesIndex < numberOfSeries; seriesIndex++) {
		
		// Get the number of values to Plot 
		NSUInteger numberOfValues = [self.chart.dataSource  numberOfValuesForSeries:self.chart withSeriesIndex:seriesIndex];
		
		// loop throught the values
		for (NSUInteger valueIndex = 0; valueIndex < numberOfValues; valueIndex++) {
			
			// get the value from the datasource
			NSNumber * val = [self.chart.dataSource numberForSeries:self.chart withSeriesIndex:seriesIndex field:[self type] valueIndex:valueIndex]; 
			
			// If we are looking for the max and the new value is larger than the existing use the new and vice versa
			if ((isMax && [val doubleValue] > extreme) || (!isMax && [val doubleValue] < extreme)) {
				extreme = [val doubleValue];
			}
			// DebugLog(@"Determining min/max index:%li, value:%f, new extreme:%f ", (unsigned long)valueIndex, [val doubleValue], extreme);
		}
	}
	
	// beautify
	/*
	if (fabs(extreme) < 1) {
		extreme = extreme; // ceil(extreme / 0.1) * 1;
	} else if (fabs(extreme) < 10) {
		extreme = ceil(extreme) / 2 * 2;
	} else if (fabs(extreme) < 100) {
		extreme = ceil(extreme) / 10 * 10;
	} else if (fabs(extreme) < 1000) {
		extreme = ceil(extreme) / 100 * 100;
	} else if (fabs(extreme) < 10000) {
		extreme = ceil(extreme) / 1000 * 1000;
	} else if (fabs(extreme) < 100000) {
		extreme = ceil(extreme / 10000) * 10000;
	}
	*/
	return extreme;
}

- (void)setMax:(double)pValue{
	_max = pValue;
	_maxManual = pValue;
}

- (void)setMin:(double)pValue{
	_min = pValue;
	_minManual = pValue;
}

- (double)max{
	// check if max was touched
	if (_max == DBL_MIN) {
		// if no, ßrecalculate
		_max = [self getExtreme:YES withValue:DBL_MIN];
		
		if(_max && _maxManual > _max) { _max = _maxManual;};
		
		//DebugLog(@"Calculating Max for %li: %f", [self type], _max);
		
		// check if we have  to rebase
		if(_max > 0 && _max <= 1) {
			if([self.valuesFormatter isKindOfClass:[NSNumberFormatter class]]) {
				if([(NSNumberFormatter *)self.valuesFormatter numberStyle] == NSNumberFormatterPercentStyle) {
					NSLog(@"Rebase to 1.0");
					_max = 1.0;
				}
			}
			
		}
	}
	return _max;
}
- (double)min{
	// check if max was touched
	if (_min == DBL_MAX) {
		// if no, recalculate
		_min = [self getExtreme:NO withValue:DBL_MAX];

		if(_minManual && _minManual < _min) {_min = _minManual;};
		//DebugLog(@"Calculating Min for %li: %f", [self type],_min);

		// check if we have  to rebase
		if(_min > 0 && self.valuesFormatter) {
			if(![self.valuesFormatter isKindOfClass:[NSDateFormatter class]]) {
				NSLog(@"Rebase to 0");
				_min = 0;
			}
			
		}
	}
	return _min;
}
- (double)tick{
	// give the tick value
	return ([self max] - [self min]) / _tickCount;
}

- (NSInteger)tickCount{
	// return the ticks
	if(!self.valuesFormatter) {
		_tickCount = (NSInteger)[self max] - (NSInteger)[self min] + 1;
		if(_tickCount > 100 )  {
			_tickCount = 100;
		} else if (_tickCount <= 0) {
			_tickCount = 5;
		}
	} else {
		_tickCount =  5;
 	}
	if(_tickCount == 96) {
		_tickSkip = 11;
	} else if(_tickCount == 30 || _tickCount == 31) {
		_tickSkip = 4;
	} else if(_tickCount == 28 || _tickCount == 29) {
		_tickSkip = 4;
	} else if(_tickCount == 52) {
		_tickSkip = 3;
	} else if(_tickCount == 24) {
		_tickSkip = 5;
	} else {
		_tickSkip = 0;
	}
	return _tickCount;
}
- (void)setTickCount:(NSInteger)pValue{
	_tickCount = pValue;
}

- (double)factor {
	double result;
	
	result = self.dimension / ([self max] - [self min]);

	return isinf(result) ? 0.0f : result;
	
}

- (void)reset {
	_min = DBL_MAX;
	_max = DBL_MIN;
}

@end
