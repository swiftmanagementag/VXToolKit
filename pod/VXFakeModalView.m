//
//  FakeModalView.m
//  hunt
//
//  Created by Graham Lancashire on 24.09.13.
//  Copyright (c) 2013 Swift Management AG. All rights reserved.
//

#import "VXFakeModalView.h"

@interface VXFakeModalView ()
@property (nonatomic, retain) UIViewController *rootVC;
@end
@implementation VXFakeModalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
		
        [self setBackgroundColor: [UIColor clearColor]];
        _rootVC = self.rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController] ;
        self.frame = _rootVC.view.bounds; // to make this view the same size as the application

		_background = [[UIView alloc] initWithFrame:self.bounds];
        [_background setBackgroundColor:[UIColor blackColor]];
        [_background setOpaque:NO];
        [_background setAlpha:0.7]; // make the background semi-transparent
		
        CGRect screenSize = [[UIScreen mainScreen] bounds];
		double margin = 30.0f;
		
		_webView = [[UIWebView alloc] initWithFrame:CGRectMake(margin, margin, screenSize.size.width - 2 * margin, screenSize.size.height - 2 * margin)];
		_webView.opaque= YES;
		_webView.backgroundColor= [UIColor blackColor];
		
		UIButton *button=[[UIButton alloc] init];
		
		button.frame = screenSize;
		
		[button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
		
        [self addSubview:_background]; // add the background
        [self addSubview:button];
		[self addSubview:_webView]; // add the web view on top of it
    }
    return self;
}

-(void)showWithHtml:(NSString*)pContent {
	// get baseurl - ensures display of images
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	// display if there is a html
	if (pContent) {
		[self.webView loadHTMLString:pContent baseURL:baseURL];
	}
	
	double pInterval = 8.0;
	[self performSelector:@selector(close) withObject:nil afterDelay:pInterval];
	
    [self.rootVC.view addSubview:self]; // show the fake modal view
}

-(void)close {
	
    [self removeFromSuperview]; // hide the fake modal view
}

@end
