//
//  VXChartMarker.m
//  iTheorie
//
//  Created by Graham Lancashire on 24.02.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import "VXChartMarker.h"
#import "UIFont+Category.h"
#import "VXConfiguration.h"

@interface VXChartMarker (PrivateMethods)

- (void)initializeComponent;

@end

@implementation VXChartMarker

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
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

- (void)drawRect:(CGRect)rect {
    // Drawing code
}



#pragma mark PrivateMethods

- (void)initializeComponent {
	//DebugLog(@"Initialising Marker %i", [self index]);
	
	// Setting default values
	_color = [UIColor blueColor];
	_font = [UIFont defaultFontOfSize:kVXTableFontSmallSize];
	_title = @"";
	
	_lineSize = 0.5f;
	
}


@end
