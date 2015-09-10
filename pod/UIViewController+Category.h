//
//  UIViewController+Category.h
//  iTheorie
//
//  Created by Graham Lancashire on 07.12.11.
//  Copyright (c) 2011 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CompatibleParentController)
@property (NS_NONATOMIC_IOSONLY, readonly, strong) UIViewController *compatibleParentController;
-(void)setFont ;
@end
