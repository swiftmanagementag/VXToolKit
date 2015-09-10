//
//  VXBadgedCell.h
//  iTheorie
//
//  Created by Graham Lancashire on 28.01.10.
//  Copyright 2010 Swift Management AG. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface VXBadgeView : UIView {}

@property  NSInteger width;
@property  NSInteger height;
@property (nonatomic, strong) NSString *text;
@property (nonatomic,strong) UITableViewCell *parent;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont  *font;

@property (nonatomic, strong) UIColor *badgeColor;
@property (nonatomic, strong) UIColor *badgeColorHighlighted;
@property double badgeAlpha;

@property (nonatomic, strong) UIColor *borderColor;
@property double borderWidth;
@property (nonatomic, strong) UIColor *shadowColor;
@property double shadowWidth;
@property double cornerRadius;
@property double minimumWidth;
@property double forceWidth;
@property double forceHeight;
@property UITextAlignment textAlign;

@end

@interface VXBadgedCell : UITableViewCell {}

@property (nonatomic, strong) NSString *badgeText;
@property (nonatomic, strong) VXBadgeView *badgeView;
@property (nonatomic, strong) UIColor *badgeColor;
@property (nonatomic, strong) UIColor *badgeColorHighlighted;
@property (nonatomic, strong) UIColor *badgeTextColor;
@property (nonatomic, strong) UIFont  *badgeFont;

@property (nonatomic, strong) UIColor *badgeBorderColor;
@property double badgeBorderWidth;

@property (nonatomic, strong) UIColor *badgeShadowColor;
@property double badgeShadowWidth;
@property double badgeCornerRadius;
@property double badgeWidth;
@property double badgeHeight;
@property UITextAlignment badgeTextAlign;
@property double marginRight;

@property double badgeAlpha;

@end
