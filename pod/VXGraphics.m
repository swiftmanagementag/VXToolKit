//
//  VXGraphics.m
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "VXGraphics.h"

CGRect rectFor1PxStroke(CGRect rect) {
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);
}

UIColor* dimmedColor(UIColor *pColor, double factor) {
    CGFloat a, r, g, b, w;
    UIColor *endColor;
    
    const CGFloat *components = CGColorGetComponents(pColor.CGColor);

    if(CGColorGetNumberOfComponents(pColor.CGColor) > 3) {
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
        endColor = [UIColor colorWithRed:r * factor green:g * factor blue:b * factor alpha:a];
    } else {
        w = components[0];
        a = components[1];
        endColor = [UIColor colorWithWhite:w * factor alpha:a];
    }
    return endColor;
}


void drawLinearGradient(CGContextRef context, CGRect rect, UIColor* startColor, UIColor* endColor, BOOL vertical) {
    // Create Colorspace
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(startColor.CGColor);
    // Locations of colors withing the gradient 0 means beginning, 1 means end of the gradient
    CGFloat locations[] = { 0.0, 1.0 };
    
	
	
    // Build array of colors
    NSArray *colors = @[(id)[startColor CGColor], endColor != nil ? (id)[endColor CGColor] : (id)dimmedColor(startColor, 0.3).CGColor];
	
    // Create the gradient
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    // Draw gradient from top middle to bottom middle -> maybe change for vertical bars
    CGPoint startPoint;
    CGPoint endPoint; 
    if(vertical == YES) {
       startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
       endPoint= CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    } else {
        startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
        endPoint= CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
    }
    // Save state
    CGContextSaveGState(context);
    
    // Add a rectangle for clipping and clip
    CGContextAddRect(context, rect);
    CGContextClip(context);
    
    // Draw gradient withing clipped area
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // Restore state
    CGContextRestoreGState(context);
    
    // Clean up the gradient and color space
    CGGradientRelease(gradient);
}

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, UIColor* pColor) {
    
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, pColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);        
    
}