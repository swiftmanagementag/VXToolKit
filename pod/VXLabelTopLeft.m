//
//  VXLabelTopLeft.m
//  davidoff
//
//  Created by Graham Lancashire on 17.08.11.
//  Copyright 2011 Swift Management AG. All rights reserved.
//

#import "VXLabelTopLeft.h"

@implementation VXLabelTopLeft

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame 
{
    return [super initWithFrame:frame];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines 
{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];    
    textRect.origin.y = bounds.origin.y;
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect 
{
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
