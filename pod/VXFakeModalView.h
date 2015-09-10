//
//  FakeModalView.h
//  hunt
//
//  Created by Graham Lancashire on 24.09.13.
//  Copyright (c) 2013 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VXFakeModalView : UIView
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIView *background; // this will cover the entire screen

-(void)showWithHtml:(NSString*)pContent;
-(void)close; // this will close the fake modal view
@end
