//
//  SFBadgedCell.h
//  iTheorie
//
//  Created by Graham Lancashire on 28.01.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//

#import "VXBadgedCell.h"
#import "UIFont+Category.h"
#import <QuartzCore/QuartzCore.h>
#import "ITConfiguration.h"

#define kBadgeHeightFactor 1.6f

@implementation VXBadgeView

- (instancetype) initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}
- (CGPathRef)addRoundedRect:(CGRect)rect radius:(CGFloat)radius{
	CGMutablePathRef retPath = CGPathCreateMutable();

	CGRect innerRect = CGRectInset(rect, radius, radius);
	
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
	
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
	
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
	
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
	
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
	
	CGPathCloseSubpath(retPath);
	
	return retPath;
}
// get text width
- (double) textWidth {
	return [self.text sizeWithFont:self.font].width;
}
// get text width
- (double) textHeight {
	return [self.text sizeWithFont:self.font].height;
}
- (void) calculateSize {
	float badgeWidth = kVXBadgeWidth;

    if(([self textWidth] + kVXMargin) > badgeWidth) {
        badgeWidth =  [self textWidth] + kVXMargin;
    }
    
	if(self.forceWidth > 0.0f) {
		self.width = self.forceWidth;
	} else if(self.minimumWidth > badgeWidth) {
		self.width = self.minimumWidth;
	} else {
		self.width = badgeWidth;
	}
	
	if(self.forceHeight > 0.0f) {
		self.height = self.forceHeight;
	} else {
		self.height = kVXTableFontSize * kBadgeHeightFactor;
	}
}
- (void) drawRect:(CGRect)rect {
	[self calculateSize];
	
	CGRect bounds = CGRectMake(0 , 0, self.width, self.height);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	UIColor *col;
	
	if(self.parent.highlighted || self.parent.selected) {
		if(self.badgeColorHighlighted)
			col = self.badgeColorHighlighted;
		else
			col = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];

        col = [col colorWithAlphaComponent:self.badgeAlpha];

		CGContextSetFillColorWithColor(context, [col CGColor]);
	} else {
		
		if(self.badgeColor)
			col = self.badgeColor;
		else
			col = [UIColor colorWithRed:0.530 green:0.600 blue:0.738 alpha:1.000];
		
        col = [col colorWithAlphaComponent:self.badgeAlpha];
        
    	CGContextSetFillColorWithColor(context, [col CGColor]);
	}
	
	if(self.shadowWidth != 0.0f) {
		CGContextSetShadowWithColor(context, CGSizeMake(self.shadowWidth, self.shadowWidth), self.shadowWidth, [UIColor darkGrayColor].CGColor );
	}
	
	if(self.borderWidth != 0.0f) {
		CGContextSetStrokeColorWithColor(context, [[UIColor colorWithWhite:1.0 alpha:0.950] CGColor]);
		CGContextSetLineWidth(context, self.borderWidth);
	}
	CGContextBeginPath(context);
	//	CGContextAddArc(context, radius + self.borderWidth, radius + self.borderWidth, radius, M_PI / 2 , 3 * M_PI / 2, NO);
	//	CGContextAddArc(context, bounds.size.width - radius - self.borderWidth, radius +self.borderWidth, radius, 3 * M_PI / 2, M_PI / 2, NO);
	CGRect rectBadge = CGRectMake(self.borderWidth, self.borderWidth, self.width - self.borderWidth * 2.0f, self.height- self.borderWidth * 2.0f);
	CGContextAddPath(context, [self addRoundedRect:rectBadge radius:self.cornerRadius]);
	
	CGContextClosePath(context);
	
	if(self.borderWidth != 0.0f) {
		CGContextDrawPath(context, kCGPathFillStroke);
	} else {
		CGContextFillPath(context);
	}
	
	CGContextRestoreGState(context);
	
	
	if (self.textColor) {
		CGContextSetFillColorWithColor(context,  [self.textColor CGColor]);
	} else {
		CGContextSetBlendMode(context, kCGBlendModeClear);
	}
	double textX = 0.0f;
	switch (self.textAlign) {
		case NSTextAlignmentCenter:
			textX = (bounds.size.width - [self textWidth]) / 2 + 0.5f;
			break;
		case NSTextAlignmentRight:
			textX = (bounds.size.width - [self textWidth]) - 2.5f;
			break;
			
		default:
			break;
	}
	double textY = (bounds.size.height - [self textHeight]) / 2 + 0.5f;;
	
	CGRect textBounds = CGRectMake(textX, textY, [self textWidth], self.height);
	
	[self.text drawInRect:textBounds withFont:self.font];
	
}



@end


@implementation VXBadgedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		self.badgeView = [[VXBadgeView alloc] initWithFrame:CGRectZero];
		[self.badgeView setParent:self];
		
		//redraw cells in accordance to accessory
		float version = [[[UIDevice currentDevice] systemVersion] floatValue];
		
		self.marginRight = 1.5f * kVXMargin;
		self.badgeCornerRadius = -1.0f;
		self.badgeWidth = -1.0f;
		self.badgeHeight = -1.0f;
		self.badgeTextAlign = NSTextAlignmentCenter;
		
		self.badgeBorderWidth = -1;
		self.badgeAlpha = 1.0;
		if (version <= 3.0)
			[self addSubview:self.badgeView];
		else 
			[self.contentView addSubview:self.badgeView];

		[self.badgeView setNeedsDisplay];
		
    }
    return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	if(self.badgeText.length > 0) {
		//force badges to hide on edit.
		if(self.editing)
			[self.badgeView setHidden:YES];
		else
			[self.badgeView setHidden:NO];

		// configure border and color
		if(self.badgeBorderWidth == -1 ) {
			self.badgeBorderWidth = 2;
		};
		if(self.badgeBorderColor == nil ) {
			self.badgeBorderColor = [UIColor whiteColor];
		}
		self.badgeView.borderWidth = self.badgeBorderWidth;
		self.badgeView.borderColor = self.badgeBorderColor;
		self.badgeView.shadowWidth = self.badgeShadowWidth;
		self.badgeView.shadowColor = self.badgeShadowColor;
		
		self.badgeView.forceWidth = self.badgeWidth;
		self.badgeView.minimumWidth = kVXBadgeWidth;
		self.badgeView.forceHeight = self.badgeHeight;
		self.badgeView.textAlign = self.badgeTextAlign;

		// configure colors
		if(self.badgeColorHighlighted) {
			self.badgeView.badgeColorHighlighted = self.badgeColorHighlighted;
		} else {
			self.badgeView.badgeColorHighlighted = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
		}
		self.badgeView.textColor = self.badgeTextColor;
		
		if(self.badgeColor) {
			self.badgeView.badgeColor = self.badgeColor;
		} else {
			self.badgeView.badgeColor = [UIColor colorWithRed:0.530 green:0.600 blue:0.738 alpha:1.000];
        }
        
        self.badgeView.badgeAlpha = self.badgeAlpha;

		// configure font
        if(self.badgeFont == nil) {
			self.badgeFont = [UIFont boldDefaultFontOfSize:kVXTableFontSize];
		}
		self.badgeView.font = self.badgeFont;
		
		[self.badgeView setText:self.badgeText];
		[self.badgeView setParent:self];
		[self.badgeView calculateSize];
		
		// this has to happen after the size calculation
		if(self.badgeCornerRadius > 0.0f) {
			self.badgeView.cornerRadius = self.badgeCornerRadius;
		} else {
			self.badgeView.cornerRadius = self.badgeView.height / 2.5f;
        }
		// configure margins

		double badgeX = self.contentView.frame.size.width - self.badgeView.width - self.marginRight ;
		double badgeY = round((self.contentView.frame.size.height - self.badgeView.height) / 2);
		
		CGRect badgeframe = CGRectMake(badgeX, badgeY, self.badgeView.width, self.badgeView.height);
		
		[self.badgeView setFrame:badgeframe];

		// set frame and adjust if necessary
		CGFloat textWidth = self.contentView.frame.size.width - self.badgeView.width - 2 * self.marginRight - self.textLabel.frame.origin.x;

		// Adjust
		self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, textWidth, self.textLabel.frame.size.height);
		self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, self.detailTextLabel.frame.origin.y, textWidth, self.detailTextLabel.frame.size.height);
		[self.badgeView setNeedsDisplay];
	} else {
		[self.badgeView setHidden:YES];
	}
	
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	[self.badgeView setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	[self.badgeView setNeedsDisplay];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	if (editing) {
		self.badgeView.hidden = YES;
		[self.badgeView setNeedsDisplay];
		[self setNeedsDisplay];
	} else {
		self.badgeView.hidden = NO;
		[self.badgeView setNeedsDisplay];
		[self setNeedsDisplay];
	}
}




@end