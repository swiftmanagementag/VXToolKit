#import "VXChartView.h"

@interface VXChartView (PrivateMethods)

- (void)initializeComponent;

@end
#define kVXChartMinMargin 16.0f
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

@implementation VXChartView

CGRect originalBounds;

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
-(void)addSeries:(NSInteger)pIndex withSeries:(VXChartSeries *)pSeries {
	[self.series setValue:pSeries forKey:[NSString stringWithFormat:@"%li", (long)pIndex]];
}
-(void)addMarker:(NSInteger)pIndex withMarker:(VXChartMarker *)pMarker {
	[self.markers setValue:pMarker forKey:[NSString stringWithFormat:@"%li", (long)pIndex]];
}


- (void)drawGrid:(VXChartAxis *)pAxis withContext:(CGContextRef)c{
	// DebugLog(@"Drawing grid");
	NSString *valueStringLast = @"";
	double lastPos = 0;
	NSUInteger tickCount = [pAxis tickCount];

	// DebugLog(@"Tickcount %li", (unsigned long)tickCount);
	
	// loop through the ticks
	for (NSUInteger i = 0; i <= tickCount; i++) {
		// DebugLog(@"Drawing Tick %lu / %lu", (unsigned long)i, (unsigned long)tickCount);
		
		// get value as coordinate
		CGFloat coord = ((double)i * [pAxis tick] * [pAxis factor]);
		
		// Correct if the coordinate is larger than the dimension
		if(coord > pAxis.dimension) {
			coord = pAxis.dimension;
		}

		CGPoint startPoint;
		CGPoint endPoint;
		
		if (([pAxis drawGrid] && !(self.type == kChartBar && !pAxis.valuesFormatter)) || i == 0 || i == tickCount) {
			// DebugLog(@"Drawing Line %lu", (unsigned long)i);
			
			// Set up line (no dash for the first one
			if(i == 0 || i == tickCount ) {
				CGContextSetLineDash(c, 0.0f, NULL, 0);
				CGContextSetLineWidth(c, 0.5f);
			} else {
				CGFloat lineDash[2];
				lineDash[0] = 1.0f;
				lineDash[1] = 1.0f;
				
				CGContextSetLineDash(c, 0.0f, lineDash, 2);
				CGContextSetLineWidth(c, 0.3f);
			}
	
			CGContextSetStrokeColorWithColor(c, [pAxis gridColor].CGColor);
			
			// Check which axis we are drawing
			if(pAxis.type == kAxisX) {
				// draw vertical lines 
				startPoint = CGPointMake(self.offsetX + coord, self.offsetY);
				endPoint =   CGPointMake(self.offsetX + coord, self.offsetY + self.axisY.dimension);
			} else {
				// draw horizontal lines
				startPoint = CGPointMake(self.offsetX,                        self.offsetY + pAxis.dimension - coord);
				endPoint =   CGPointMake(self.offsetX + self.axisX.dimension, self.offsetY + pAxis.dimension - coord);
			}
			//DebugLog(@"Plotting Start Grid Axis: %li x:%f y:%f", pAxis.type, startPoint.x, startPoint.y);
			
			//DebugLog(@"Plotting End Grid Axis: %li x:%f y:%f", pAxis.type, endPoint.x, endPoint.y);
			
			// draw line
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextStrokePath(c);
		}
		
		// draw labels for x axis and for y axis larger than first
		if ((i > 0 || [pAxis type] == kAxisX) && [pAxis drawGrid]) {
            NSString *valueString = NSLocalizedString(@"Missing Data", nil);
            
            BOOL isDisplay = YES;
		
			if(pAxis.min != DBL_MAX) {
                // calculate the the label 
                NSNumber *valueToFormat = nil;
                if ([pAxis valuesFormatter]) {
                    valueToFormat = @((double)i * [pAxis tick] + pAxis.min);
                } else {
                    valueToFormat = [NSNumber numberWithInteger:i + 1];
                }
                if(pAxis.tickSkip > 0 && i > 0 && (i + 1) % (pAxis.tickSkip + 1) != 0) {
                    isDisplay = NO;
                } else if (i == tickCount) {
                    isDisplay = YES;
                }
                
                // use the formatted to determine the label
                if ([pAxis valuesFormatter]) {
                
                    // special handling for dates
                    if([pAxis.valuesFormatter isKindOfClass:[NSDateFormatter class]]) {
                        NSLog(@"Value:%f",[valueToFormat doubleValue]);
                        valueString = [[pAxis valuesFormatter] stringForObjectValue:[NSDate dateWithTimeIntervalSince1970:[valueToFormat doubleValue]]];	
                    } else {
                        valueString = [[pAxis valuesFormatter] stringForObjectValue:valueToFormat];
                    }
                } else {
                    valueString = [valueToFormat stringValue];
                }
			}
            
			if (isDisplay && ![valueString isEqualToString:valueStringLast]) {
				valueStringLast = [NSString stringWithString:valueString];
				
				CGRect valueStringRect;
				
				CGSize labelSize = [valueString sizeWithAttributes:@{NSFontAttributeName:pAxis.font}];

				if(self.type == kChartBar && !pAxis.valuesFormatter) {
					coord = coord + ([pAxis factor] * .4f);
				}
				
				// Calculate the rectangle for the label
				if(pAxis.type == kAxisX) {
					if((self.offsetX + coord + labelSize.width / 2) > (self.offsetX + self.axisX.dimension)) {
						isDisplay = NO;
					} else if(lastPos > (self.offsetX + coord - labelSize.width / 2)) {
						isDisplay = NO;
					} else {
						lastPos = self.offsetX + coord + labelSize.width / 2;
					
					}
					valueStringRect = CGRectMake(self.offsetX + coord - labelSize.width / 2, self.offsetY + self.axisY.dimension + labelSize.height  / 2, labelSize.width, labelSize.height); 
				} else {
					valueStringRect = CGRectMake(kVXChartMinMargin,  self.offsetY + self.axisY.dimension - coord - labelSize.height / 2, labelSize.width, labelSize.height); 
				}

				// draw the label
				if(isDisplay == YES && !isnan(coord)) {
					NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
					/// Set line break mode
					paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
					/// Set text alignment
					paragraphStyle.alignment = NSTextAlignmentRight;
					
					[valueString drawInRect:valueStringRect withAttributes:@{NSForegroundColorAttributeName:pAxis.valuesColor, NSFontAttributeName:pAxis.font, NSParagraphStyleAttributeName: paragraphStyle}];
				}
			}
		}
	}
}
	
-(void)setToLandscape {
	CGRect screenSize = [[UIScreen mainScreen] bounds];
	
	[self setCenter:CGPointMake(screenSize.size.height / 2 , screenSize.size.width / 2)];
	
	
	CGAffineTransform cgCTM = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
	self.transform = cgCTM;
	self.bounds = screenSize;
	[self setNeedsDisplay];
}
-(void)setToPortrait {
	
	[self setCenter:CGPointMake(originalBounds.size.width  / 2, originalBounds.size.height  / 2)];
	
	CGAffineTransform cgCTM = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
	self.transform = cgCTM;
	self.bounds =originalBounds;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	// Setup the drawing area
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	// Fill the drawing area with the background color
	CGContextSetFillColorWithColor(c, self.backgroundColor.CGColor);
	CGContextFillRect(c, rect);
	
	// get the number of Plots
	NSUInteger numberOfSeries = [self.dataSource numberOfSeries:self];
	
	// return if there are none
	if (!numberOfSeries) {
		return;
	}
	
	// Calculate Chart Dimensions
	self.offsetX = self.axisY.drawAxis ? 60.0f : kVXChartMinMargin;
	self.offsetY = kVXChartMinMargin;

	self.axisX.dimension = self.bounds.size.width - self.offsetX - kVXChartMinMargin;
	self.axisY.dimension = self.bounds.size.height - self.offsetY - (self.axisX.drawAxis ? kVXChartMinMargin * 2 : kVXChartMinMargin);
	
	// Draw the grids x+y
	[self drawGrid:self.axisX withContext:c]; 
	[self drawGrid:self.axisY withContext:c]; 
	
	for (NSUInteger seriesIndex = 0; seriesIndex < numberOfSeries; seriesIndex++) {
		[self drawSeries:seriesIndex];
	}
	
	// get the number of Plots
	for(NSString *aKey in self.markers){
		NSNumber *x;
		NSNumber *y;
		
		VXChartMarker *marker = (VXChartMarker *)[self.markers  valueForKey:aKey];
		
		// initialise the line
		CGContextSetLineWidth(c, marker.lineSize);
		CGContextSetLineDash(c, 0, NULL, 0);
		CGContextSetStrokeColorWithColor(c, marker.color.CGColor);
		
		if(marker.type == kMarkerY) {
			x = @(self.axisX.min); 
			y = @(marker.y);
		} else { //  if (marker.type == kMarkerX) {
			x = @(marker.x); 
			y = @(self.axisY.min);
		}

		// calculate the starting point
		CGPoint startPoint = CGPointMake((([x doubleValue] - self.axisX.min ) * self.axisX.factor) + self.offsetX, self.axisY.dimension + self.offsetY - (([y doubleValue] - self.axisY.min) * self.axisY.factor));
			
		if(marker.type == kMarkerY) {
			x = @(self.axisX.max);
			y = @(marker.y);
		} else if (marker.type == kMarkerX) {
			x = @(marker.x); 
			y = @(self.axisY.max);
		}
		
		// calculate the endpoint
		CGPoint endPoint = CGPointMake((([x doubleValue] - self.axisX.min) * self.axisX.factor) + self.offsetX, self.axisY.dimension + self.offsetY - (([y doubleValue] - self.axisY.min ) * self.axisY.factor));
			
		// Draw line
		CGContextMoveToPoint(c, startPoint.x, startPoint.y);
		CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
		CGContextClosePath(c);
		CGContextStrokePath(c);
		
		// Draw label with rounded corners
		if(marker.title && marker.title.length > 0 ) {
			CGRect markerStringRect;
		
			CGSize labelSize = [marker.title sizeWithAttributes:@{NSFontAttributeName:marker.font}];

			markerStringRect = CGRectMake(endPoint.x * .75 - (labelSize.width * 1.8 / 2), endPoint.y - (labelSize.height * 1.2 / 2) , labelSize.width * 1.8, labelSize.height * 1.2); 
		
			[[marker color] set];
			CGContextFillRect(c, markerStringRect);
			
			// draw the label
			markerStringRect = CGRectMake(endPoint.x * .75 - (labelSize.width / 2), endPoint.y - (labelSize.height  / 2) , labelSize.width, labelSize.height ); 
			
			NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
			/// Set line break mode
			paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
			/// Set text alignment
			paragraphStyle.alignment = NSTextAlignmentCenter;
			
			[marker.title drawInRect:markerStringRect withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:marker.font, NSParagraphStyleAttributeName: paragraphStyle}];
		}
	}	
}
- (void)drawSeries:(NSUInteger)pSeries {
}
- (void)reloadData {
	[[self axisX] reset];
	[[self axisY] reset];
	
	[self setNeedsDisplay];
}


#pragma mark PrivateMethods

- (void)initializeComponent {
	self.type = kChartUndefined;

	// initialise the chart
	originalBounds = self.bounds;
	//DebugLog(@"Initialising Chart");
	
	self.axisX = [[VXChartAxis alloc] init];
	self.axisX.type = kAxisX;
	self.axisX.chart = self;
	
	self.axisY = [[VXChartAxis alloc] init];
	self.axisY.type = kAxisY;
	self.axisY.chart = self;
	
	self.series = [[NSMutableDictionary alloc] init];
	self.markers = [[NSMutableDictionary alloc] init];
}


@end
