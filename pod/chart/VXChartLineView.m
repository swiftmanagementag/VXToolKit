//
//  VXChartLineView.m
//  EnergiePilot
//
//  Created by Graham Lancashire on 08.04.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import "VXChartLineView.h"


@implementation VXChartLineView


- (void)drawSeries:(NSUInteger)pSeries {
	// Setup the drawing area
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	// get number of records
	NSUInteger numberOfValues = [self.dataSource numberOfValuesForSeries:self withSeriesIndex:pSeries];
	
	if(numberOfValues > 1) {
		NSNumber *x;
		NSNumber *y;
		
		
		// get Plot color
		CGColorRef seriesColor = [UIColor redColor].CGColor;
		double lineSize = 1.5f;
		
		if([self.series count] != 0) {
			VXChartSeries *serie = (VXChartSeries *)[self.series valueForKey:[NSString stringWithFormat:@"%li", (unsigned long)pSeries]];
			seriesColor = serie.color.CGColor;
			lineSize = serie.lineSize;
		}
		
		// initialise the line
		CGContextSetLineWidth(c, lineSize);
		CGContextSetLineDash(c, 0, NULL, 0);
		CGContextSetStrokeColorWithColor(c, seriesColor);
		
		// loop through values
		for (NSUInteger valueIndex = 0; valueIndex < numberOfValues - 1; valueIndex++) {
			// get first x + y value
			x = [self.dataSource numberForSeries:self withSeriesIndex:pSeries field:kAxisX valueIndex:valueIndex]; 
			y = [self.dataSource numberForSeries:self withSeriesIndex:pSeries field:kAxisY valueIndex:valueIndex]; 
			
			// DebugLog(@"Plotting From series: %lu point: value: %lu x:%f xv: %f min: %f y:%f", (unsigned long)pSeries, (unsigned long)valueIndex,[x doubleValue] - self.axisX.min, [x doubleValue] , self.axisX.min, [y doubleValue] - self.axisY.min);
			
			// calculate the starting point
			CGPoint startPoint = CGPointMake((([x doubleValue] - self.axisX.min ) * self.axisX.factor) + self.offsetX, self.axisY.dimension + self.offsetY - (([y doubleValue] - self.axisY.min) * self.axisY.factor));
			
			// get the next x+y values
			x = [self.dataSource numberForSeries:self withSeriesIndex:pSeries field:kAxisX valueIndex:valueIndex + 1]; 
			y = [self.dataSource numberForSeries:self withSeriesIndex:pSeries field:kAxisY valueIndex:valueIndex + 1]; 
			
			// DebugLog(@"Plotting To series: %lu point: value: %lu x:%f xv: %f min: %f y:%f", (unsigned long)pSeries, (unsigned long)valueIndex,[x doubleValue] - self.axisX.min, [x doubleValue] , self.axisX.min, [y doubleValue] - self.axisY.min);
			
			// calculate the endpoint
			CGPoint endPoint = CGPointMake((([x doubleValue] - self.axisX.min) * self.axisX.factor) + self.offsetX, self.axisY.dimension + self.offsetY - (([y doubleValue] - self.axisY.min ) * self.axisY.factor));
			
			// Draw line
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			// 
			CGContextStrokePath(c);
		}
		
	}
}

- (void)initializeComponent {
	// has to be called first
	[super initializeComponent];
	
	self.type = kChartLine;

	
}

@end
