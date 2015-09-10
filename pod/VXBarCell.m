//
//  VXBardCell.h
//  iTheorie
//
//  Created by Graham Lancashire on 28.01.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import "VXBarCell.h"
#import "VXGraphics.h"
#import "UIFont+Category.h"
#import "ITConfiguration.h"

@implementation VXBarItem
@end


@implementation VXBarView

- (instancetype) initWithFrame:(CGRect)frame {
	
	if ((self = [super initWithFrame:frame])) {
		self.font = [UIFont defaultFontOfSize:kVXTableFontSmallSize] ;
		self.backgroundColor = [UIColor clearColor];
        self.barGradientEffect = 0.4f;
	}
	
	return self;
}

- (void) drawBar:(double)pX withWidth:(double)pWidth withHeight:(double)pHeight withColor:(UIColor *)pColor {
    // Get Context and Save State
    CGContextRef context = UIGraphicsGetCurrentContext();
   
    CGRect rectBar = CGRectMake(pX, 0, pWidth, pHeight);
    
    if(self.barGradientEffect != 0) {
        drawLinearGradient(context, rectBar, pColor, dimmedColor(pColor, self.barGradientEffect), TRUE);
        
        if(pX == 0) {
            draw1PxStroke(context, CGPointMake(0, 0), CGPointMake(0, pHeight),pColor);
        }
        draw1PxStroke(context, CGPointMake(pX, 0), CGPointMake(pX + pWidth, 0),pColor);
        draw1PxStroke(context, CGPointMake(pX, pHeight), CGPointMake(pX + pWidth, pHeight),pColor);
        draw1PxStroke(context, CGPointMake(pX + pWidth - 1, 0), CGPointMake(pX + pWidth - 1, pHeight),pColor);
    } else {
        CGContextSetFillColorWithColor(context, pColor.CGColor);
        CGContextFillRect(context, rectBar);
        
    }
}

- (void) drawRect:(CGRect)rect
{
    DebugLog(@"Get total", nil);
    
    double total = [self getTotal];

    if (self.items == nil || [self.items count ] == 0 || total == 0) {
        return;
    }

    DebugLog(@"Get total", nil);
    if(self.font == nil) {
        self.font = [UIFont defaultFontOfSize:kVXTableFontSmallSize] ;
        self.backgroundColor = [UIColor clearColor];
	}
    
    DebugLog(@"Calculate", nil);
    double totalWidth = rect.size.width;
    double totalHeight = rect.size.height;
    double offset = 0;
    UIColor *color = nil;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
	
    DebugLog(@"Total: %f, width: %f", total, totalWidth);
    
    
    for (VXBarItem *barItem in self.items) {
        double percent = (barItem.value / total );
        double barWidth = round(totalWidth * percent);
        
        if(barWidth >= 1.0f) {
            color = barItem.color;
            [self drawBar:offset withWidth:barWidth withHeight:totalHeight withColor:color];
	
            if(percent >= 0.1f) {
                
                CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
                NSString *label = [NSString stringWithFormat:barItem.text, percent * 100.0  ];
                CGSize size = [label sizeWithFont:self.font];
                [label drawInRect:CGRectMake(offset + (barWidth - size.width) / 2, (totalHeight - size.height) / 2, size.width, size.height) withFont:self.font];
 
            }
            offset += barWidth;
        }

    }

    // Make sure that all the bars have the same width (rounding issues)
    if(color != nil && offset < totalWidth) {
        [self drawBar:offset withWidth:totalWidth - offset withHeight:totalHeight withColor:color];
    }
    
    // draw frame
    if(self.borderColor != nil && self.borderWidth > 0) {
      // draw border
        CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
        CGContextSetLineWidth(context, self.borderWidth);
        CGContextStrokeRect(context, CGRectMake(self.borderWidth / 2 - 0.5f, self.borderWidth / 2  -    0.5f, totalWidth - self.borderWidth + .5f, totalHeight-self.borderWidth + .5f));
    }
    CGContextRestoreGState(context);
	
}

- (double) getTotal {
    double total = 0;
    
    if(self.items != nil) {
        for(VXBarItem *barItem in self.items) {
            total += [barItem value];
        }
    }
    return total;
}


@end


@implementation VXBarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		self.bar = [[VXBarView alloc] initWithFrame:CGRectZero];
		[self.bar setParent:self];
		
		//redraw cells in accordance to accessory
		float version = [[[UIDevice currentDevice] systemVersion] floatValue];
		
		if (version <= 3.0)
			[self addSubview:self.bar];
		else
			[self.contentView addSubview:self.bar];
        
        self.barAlpha = 1.0f;

		self.barGradientEffect = 0.6f;
	
        self.borderWidth = 2.0f;
		self.borderColor = [UIColor whiteColor];
		
        self.cornerRadius = 0.0f;
		
    }
    return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
    double leftMargin = kVXMargin;
    double topMargin = kVXMargin;
    double iconSize = kVXTableIcon;
    
    if([self.detailTextLabel.text length] > 0 ) {
        CGSize detailSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font];

		double factor = IS_IOS7_AND_UP ? .60f : .80f;
		
        CGRect imageFrame = self.imageView.frame;
		
		imageFrame = CGRectMake(imageFrame.origin.x, imageFrame.origin.y, imageFrame.size.width * factor, imageFrame.size.height * factor);
        [self.imageView setFrame:imageFrame];

        CGRect detailFrame = CGRectMake(self.imageView.frame.origin.x + (self.imageView.frame.size.width - detailSize.width) / 2, (self.contentView.frame.size.height - detailSize.height), detailSize.width, detailSize.height);
        [self.detailTextLabel setFrame:detailFrame];
        
    }
    
    
	float barWidth = self.contentView.frame.size.width - 3 * leftMargin - iconSize ;
		
	CGRect barframe = CGRectMake(iconSize + 2 * leftMargin, topMargin * 1.1, barWidth, self.contentView.frame.size.height - 2.2 * topMargin);

	[self.bar setFrame:barframe];
	[self.bar setParent:self];

	self.bar.barAlpha = self.barAlpha;
    self.bar.borderWidth = self.borderWidth;
    self.bar.borderColor = self.borderColor;
    self.bar.layer.cornerRadius = self.cornerRadius;
    self.bar.clipsToBounds = YES;
    self.bar.barGradientEffect = self.barGradientEffect;
    
    [self.bar setItems:self.items];
    [self.bar setNeedsDisplay];
 
}
@end