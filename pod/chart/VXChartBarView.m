//
//  VXChartBarView.m
//  EnergiePilot
//
//  Created by Graham Lancashire on 08.04.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import "VXChartBarView.h"
#import "VXGraphics.h"

@implementation VXChartBarView
- (void)drawSeries:(NSUInteger)pSeries {
	// Setup the drawing area
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextSaveGState(c);
	// get number of records
	NSUInteger numberOfValues = [self.dataSource numberOfValuesForSeries:self withSeriesIndex:pSeries];
	
	if(numberOfValues > 1) {
		NSNumber *x;
		NSNumber *y;
		
		CGRect barRect;
		double barWidth;
		double barHeight;
		double factorX = self.axisX.factor;
		
		if(!self.axisX.valuesFormatter){
			factorX = (factorX * ((double)numberOfValues - 1.0f)) / (double)numberOfValues;
		}

		VXChartSeries *serie = (VXChartSeries *)[self.series valueForKey:[NSString stringWithFormat:@"%lu", (unsigned long)pSeries]];
		
		UIColor *color = serie.color;
		
		BOOL isColorManaged = [self.dataSource respondsToSelector:@selector(colorForSeries:withSeriesIndex:field:valueIndex:)];
		
		// loop through values
		for (NSUInteger valueIndex = 0; valueIndex < numberOfValues; valueIndex++) {
			// get first x + y value
			x = [self.dataSource numberForSeries:self withSeriesIndex:pSeries field:kAxisX valueIndex:valueIndex] ; 
			y = [self.dataSource numberForSeries:self withSeriesIndex:pSeries field:kAxisY valueIndex:valueIndex]; 

			if([y doubleValue] != 0.0f) {
				barWidth = (factorX * .85) / [self.series count];
				barHeight = ([y doubleValue] - self.axisY.min ) * self.axisY.factor;
				
				// DebugLog(@"Plotting To series: %li point: value: %li x:%f y: %f", (unsigned long)pSeries, (unsigned long)valueIndex,((double)[x integerValue] - self.axisX.min), ([y doubleValue] - self.axisY.min ));
				
				if (isColorManaged) {
					color = [self.dataSource colorForSeries:self withSeriesIndex:pSeries field:kAxisX valueIndex:valueIndex]; 
				}
			
				barRect = CGRectMake((((double)[x integerValue] - self.axisX.min) * factorX) + self.offsetX + ( 0.05f * factorX) + (pSeries * barWidth * 1.1), self.axisY.dimension + self.offsetY - barHeight, barWidth, barHeight); 

				if(self.gradient) {
					float barGradientEffect = 0.3f;
					drawLinearGradient(c, barRect,color,  dimmedColor(color, barGradientEffect), FALSE);

				} else {
					CGContextSetFillColorWithColor(c, color.CGColor);
					CGContextFillRect(c, barRect);
					if(serie.borderWidth != 0.0f && serie.borderColor) {
						CGContextSetStrokeColorWithColor(c, serie.borderColor.CGColor);
						CGContextSetLineWidth(c, serie.borderWidth);
						CGContextStrokeRect(c, barRect);
					}
				}
			}
		}
	}
	CGContextRestoreGState(c);
}
- (void)initializeComponent {
	// has to be called first
	[super initializeComponent];
	
	self.type = kChartBar;

	
}
@end
