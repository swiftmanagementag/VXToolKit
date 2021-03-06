//
//  VXGraphics.h
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

void drawLinearGradient(CGContextRef context, CGRect rect, UIColor* startColor, UIColor*  endColor, BOOL vertical);

UIColor* dimmedColor(UIColor* pColor, double factor);

CGRect rectFor1PxStroke(CGRect rect);

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, UIColor* pColor);