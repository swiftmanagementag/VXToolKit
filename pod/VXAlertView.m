//
//  VXAlertView.m
//  VXAlert
//
//  Created by Aaron Crabtree on 10/14/11.
//  Copyright (c) 2011 Tap Dezign, LLC. All rights reserved.
//

#import "VXAlertView.h"
#import "UIFont+Category.h"

#import <objc/runtime.h>
@interface VXAlertView (Internal)
@property (NS_NONATOMIC_IOSONLY, readonly) CGFloat _estimatedHeight;
@end

// is implemented below
@interface VXAlertTextFieldBack : UIView
@end

@implementation VXAlertView


#pragma mark -
#pragma mark Blocks Extensions
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message completionBlock:(void (^)(NSUInteger buttonIndex))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
	objc_setAssociatedObject (self, "blockCallback", block,  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	if (self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil]) {
		
		if (cancelButtonTitle) {
			[self addButtonWithTitle:cancelButtonTitle];
			self.cancelButtonIndex = [self numberOfButtons] - 1;
		}
		
		id eachObject;
		va_list argumentList;
		if (otherButtonTitles) {
			[self addButtonWithTitle:otherButtonTitles];
			va_start(argumentList, otherButtonTitles);
			while ((eachObject = va_arg(argumentList, id))) {
				[self addButtonWithTitle:eachObject];
			}
			va_end(argumentList);
		}
	}
	return self;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	void (^block)(NSUInteger buttonIndex) = objc_getAssociatedObject(self, "blockCallback");
	block(buttonIndex);
}

#pragma mark -
#pragma mark Textfield Extensions
- (void)show {
	if([self numberOfTextFields] > 0) {
		self.transform = CGAffineTransformTranslate(self.transform, 0.0f,  150.0f);
		
		// A delay is used here, because if the show animation gets choppy if the
		// keyboard is animated up at the same time, not sure why.
		[self.firstTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.4];
	}
	
	[super show];
}

- (void)setFrame:(CGRect)frame {
	if((frame.origin.x > 0 || frame.origin.x < -1) && !overrodeHeight) {
		frame.size.height += textFieldHeightOffset;
		overrodeHeight = YES;
	}
	
	[super setFrame:frame];
}

- (void)addTextField:(UITextField*)textField {
	if(!__textFields) {
		__textFields = [[NSMutableArray alloc] initWithCapacity:1];
	}
	
	textField.backgroundColor = [UIColor clearColor];
	textField.font = [UIFont defaultFontOfSize:19.0f];
	textField.keyboardAppearance = UIKeyboardAppearanceAlert;
	
	[__textFields addObject:textField];
	
	textFieldHeightOffset = (self.numberOfTextFields * 41.0f) - 10.0f;
}

- (CGFloat)_estimatedHeight {
	CGFloat titleHeight = [self.title sizeWithFont:[UIFont boldDefaultFontOfSize:17.0f] constrainedToSize:CGSizeMake(260.0f, CGFLOAT_MAX)].height;
	CGFloat messageHeight = [self.message sizeWithFont:[UIFont defaultFontOfSize:17.0f] constrainedToSize:CGSizeMake(260.0f, CGFLOAT_MAX)].height;
	
	if(titleHeight > 0) {
		titleHeight += 10.0f;
	}
	
	if(messageHeight > 0) {
		messageHeight += 10.0f;
	}
	
	return titleHeight + messageHeight + textFieldHeightOffset + 43.0f + 30.0f; // 43.0f = button height, 35 = top/bottom padding
}

- (UITextField*)addTextFieldWithLabel:(NSString*)label {
	return [self addTextFieldWithLabel:label value:nil];
}

- (UITextField*)addTextFieldWithLabel:(NSString*)label value:(NSString*)value {
	UITextField* textField = [[UITextField alloc] initWithFrame:CGRectZero];
	textField.font = [UIFont defaultFontOfSize:textField.font.pointSize];
    
	textField.placeholder = label;
	textField.text = value;
	[self addTextField:textField];
	return textField;
}

- (UITextField*)textFieldForIndex:(NSInteger)index {
	return __textFields[index];
}

- (NSInteger)numberOfTextFields {
	return __textFields.count;
}

- (UITextField*)firstTextField {
	if([self numberOfTextFields] > 0) {
		return [self textFieldForIndex:0];
	} else {
		return nil;
	}
}- (instancetype)initWithMessage:(NSString *)pMessage dismissAfter:(NSTimeInterval)pInterval {
	// set default text
	NSString *content = [NSString stringWithFormat:@"<html><head><link rel='stylesheet' href='defaultalert.css' /></head><body><p>%@</p></body></html>", pMessage];
	
	return [self initWithHtml:content dismissAfter:pInterval];
}

- (instancetype)initWithFile:(NSString *)pFile dismissAfter:(NSTimeInterval)pInterval {
	// get file depending on key
	NSString *filePath = [[NSBundle mainBundle] pathForResource:pFile ofType:@"html"];
	
	// set default text
	NSMutableString *content = [NSMutableString stringWithFormat:@"<html><head><link rel='stylesheet' href='defaultalert.css' /></head><body><h1>%@: %@</h1></body></html>", NSLocalizedString(@"Text not found", nil), pFile];
	
	// load if the path is valid
	if (filePath) {
		content = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	}
	
	return [self initWithHtml:content dismissAfter:pInterval];
}

- (instancetype)initWithHtml:(NSString *)pContent dismissAfter:(NSTimeInterval)pInterval {
	if ((self = [super init]))
	{
		
		int margin =[UIFont systemFontSize];
        
		
		CGRect screenSize = [[UIScreen mainScreen] bounds];
		
        self.frame = CGRectMake(margin, margin, screenSize.size.width - 2 * margin, screenSize.size.height - 2 * margin);
		
        
		self.webView = [[UIWebView alloc]  initWithFrame:CGRectMake(margin,margin, screenSize.size.width - 2  * margin, 2* margin) ];
		self.webView.opaque = false;
		self.webView.backgroundColor= [UIColor clearColor];
		self.webView.delegate = self;
		
		// get baseurl - ensures display of images
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSURL *baseURL = [NSURL fileURLWithPath:path];
		
		// display if there is a html
		if (pContent) {
            [self.webView loadHTMLString:pContent baseURL:baseURL];
		}
		
		if (pInterval== 0) {
			pInterval = 8.0;
			
		}
		[self performSelector:@selector(close) withObject:nil afterDelay:pInterval];
		
		[self addSubview:self.webView];
		
		UIButton *button=[[UIButton alloc] init];
		
		button.frame = screenSize;
		
		[button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
		
		self.delegate = self;
	}
	return self;
}

// handle loading finished for webview
- (void) webViewDidFinishLoad:(UIWebView *)pWebView {
	// call layout after web content has loaded
	[self performSelector:@selector(calculateWebViewSize:) withObject:pWebView afterDelay:0.1];
}

// layout loaded html
- (void) calculateWebViewSize:(UIWebView *)pWebView {
	
	// get size from html
	float newHeight = [[pWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
	
	// calculate size for webview 6/60
	pWebView.frame = CGRectMake(pWebView.frame.origin.x, pWebView.frame.origin.y, pWebView.frame.size.width, newHeight + 6 );
	pWebView.autoresizesSubviews = TRUE;
	
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
	CGRect screenSize = [[UIScreen mainScreen] bounds];
	
    int margin = [UIFont systemFontSize];
	
    // set the frame of the alert view and center it
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		alertView.frame = CGRectMake( 4 * margin, 8 * margin, screenSize.size.width - 8 * margin, screenSize.size.height - 16 * margin);
    } else {
        alertView.frame = CGRectMake( margin, margin , screenSize.size.width - 2 * margin, screenSize.size.height - 2 * margin);
    }
    self.webView.frame = CGRectMake(margin / 2, margin / 2, alertView.frame.size.width - margin / 2, alertView.frame.size.height - margin / 2);
    
}


- (void)close
{
	[self dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark -
#pragma mark UIView Overrides
- (void)layoutSubviews {
	[super layoutSubviews];

	for (UIView *subview in self.subviews){ //Fast Enumeration
		
		if ([subview isMemberOfClass:[UIImageView class]]) { //Find UIImageView Containing Blue Background
			subview.hidden = YES; //Hide UIImageView Containing Blue Background
		}
        
		if ([subview isMemberOfClass:[UILabel class]]) { //Point to UILabels To Change Text
			UILabel *label = (UILabel*)subview;	//Cast From UIView to UILabel
			label.textColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
			if(label.font != nil ) {
				if([label.font.familyName hasSuffix:@"Bold"]) {
					label.font = [UIFont defaultFontOfSize:label.font.pointSize];
				} else {
					label.font = [UIFont defaultFontOfSize:label.font.pointSize];
				}
			}
			label.shadowColor = [UIColor blackColor];
			label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		}
		if ([subview isKindOfClass:[UIButton class]]) { //Point to UILabels To Change Text
			UIButton *button = (UIButton*)subview;	//Cast From UIView to UILabel
			if(button.titleLabel.font != nil ) {
				if([button.titleLabel.font.familyName hasSuffix:@"Bold"]) {
					button.titleLabel.font = [UIFont defaultFontOfSize:button.titleLabel.font.pointSize];
				} else {
					button.titleLabel.font = [UIFont defaultFontOfSize:button.titleLabel.font.pointSize];
				}
			}
			
		}
	}
	
	if([self numberOfTextFields] > 0) {
		for(UITextField* textField in __textFields) {
			[textField.superview removeFromSuperview];
			[textField removeFromSuperview];
		}
		
		CGFloat offsetY = 0.0f;
		
		for(UIView* view in self.subviews) {
			if(![view isKindOfClass:[UIControl class]]) {
				if(CGRectGetMaxY(view.frame) > offsetY) {
					offsetY = CGRectGetMaxY(view.frame);
				}
			}
			
			if([view isKindOfClass:[VXAlertTextFieldBack class]]) {
				[view removeFromSuperview];
			}
		}
		
		offsetY += 5.0f;
		
		for(UITextField* textField in __textFields) {
			VXAlertTextFieldBack* backView = [[VXAlertTextFieldBack alloc] initWithFrame:CGRectMake(11.0f, offsetY, 262.0f, 31.0f)];
			textField.frame = CGRectMake(5.0f, 4.0f, backView.frame.size.width-10.0f, backView.frame.size.height-9.0f);
			[backView addSubview:textField];
			[self addSubview:backView];
			
			offsetY = CGRectGetMaxY(backView.frame) + 10.0f;
		}
		
		for(UIView* view in self.subviews) {
			if([view isKindOfClass:[UIControl class]] && ![view isKindOfClass:[UITextField class]]) {
				CGRect viewRect = view.frame;
				viewRect.origin.y = offsetY;
				view.frame = viewRect;
			}
		}
	}
}

- (void)drawRect:(CGRect)rect 
{
	//////////////GET REFERENCE TO CURRENT GRAPHICS CONTEXT
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    //////////////CREATE BASE SHAPE WITH ROUNDED CORNERS FROM BOUNDS
	CGRect activeBounds = self.bounds;
	CGFloat cornerRadius = 10.0f;	
	CGFloat inset = 6.5f;	
	CGFloat originX = activeBounds.origin.x + inset;
	CGFloat originY = activeBounds.origin.y + inset;
	CGFloat width = activeBounds.size.width - (inset*2.0f);
	CGFloat height = activeBounds.size.height - (inset*2.0f);
    
	CGRect bPathFrame = CGRectMake(originX, originY, width, height);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:bPathFrame cornerRadius:cornerRadius].CGPath;
	
	//////////////CREATE BASE SHAPE WITH FILL AND SHADOW
	CGContextAddPath(context, path);
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor);
	CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 6.0f, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f].CGColor);
    CGContextDrawPath(context, kCGPathFill);
	
	//////////////CLIP STATE
	CGContextSaveGState(context); //Save Context State Before Clipping To "path"
	CGContextAddPath(context, path);
	CGContextClip(context);
	
	//////////////DRAW GRADIENT
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	size_t count = 3;
	CGFloat locations[3] = {0.0f, 0.57f, 1.0f}; 
	CGFloat components[12] = 
	{	70.0f/255.0f, 70.0f/255.0f, 70.0f/255.0f, 1.0f,     //1
		55.0f/255.0f, 55.0f/255.0f, 55.0f/255.0f, 1.0f,     //2
		40.0f/255.0f, 40.0f/255.0f, 40.0f/255.0f, 1.0f};	//3
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, count);
    
	CGPoint startPoint = CGPointMake(activeBounds.size.width * 0.5f, 0.0f);
	CGPoint endPoint = CGPointMake(activeBounds.size.width * 0.5f, activeBounds.size.height);
    
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	CGColorSpaceRelease(colorSpace);
	CGGradientRelease(gradient);
	
	//////////////HATCHED BACKGROUND
    CGFloat buttonOffset = 92.5f; //Offset buttonOffset by half point for crisp lines
	CGContextSaveGState(context); //Save Context State Before Clipping "hatchPath"
	CGRect hatchFrame = CGRectMake(0.0f, buttonOffset, activeBounds.size.width, (activeBounds.size.height - buttonOffset+1.0f));
	CGContextClipToRect(context, hatchFrame);
	
	CGFloat spacer = 4.0f;
	int rows = (activeBounds.size.width + activeBounds.size.height/spacer);
	CGFloat padding = 0.0f;
	CGMutablePathRef hatchPath = CGPathCreateMutable();
	for(int i=1; i<=rows; i++) {
		CGPathMoveToPoint(hatchPath, NULL, spacer * i, padding);
		CGPathAddLineToPoint(hatchPath, NULL, padding, spacer * i);
	}
	CGContextAddPath(context, hatchPath);
	CGPathRelease(hatchPath);
	CGContextSetLineWidth(context, 1.0f);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.15f].CGColor);
	CGContextDrawPath(context, kCGPathStroke);
	CGContextRestoreGState(context); //Restore Last Context State Before Clipping "hatchPath"
	
	//////////////DRAW LINE
	CGMutablePathRef linePath = CGPathCreateMutable(); 
	CGFloat linePathY = (buttonOffset - 1.0f);
	CGPathMoveToPoint(linePath, NULL, 0.0f, linePathY);
	CGPathAddLineToPoint(linePath, NULL, activeBounds.size.width, linePathY);
	CGContextAddPath(context, linePath);
	CGPathRelease(linePath);
	CGContextSetLineWidth(context, 1.0f);
	CGContextSaveGState(context); //Save Context State Before Drawing "linePath" Shadow
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.6f].CGColor);
	CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 0.0f, [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.2f].CGColor);
	CGContextDrawPath(context, kCGPathStroke);
	CGContextRestoreGState(context); //Restore Context State After Drawing "linePath" Shadow
	
	//////////////STROKE PATH FOR INNER SHADOW
	CGContextAddPath(context, path);
	CGContextSetLineWidth(context, 3.0f);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor);
	CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 6.0f, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f].CGColor);
	CGContextDrawPath(context, kCGPathStroke);
    
	//////////////STROKE PATH TO COVER UP PIXILATION ON CORNERS FROM CLIPPING
    CGContextRestoreGState(context); //Restore First Context State Before Clipping "path"
	CGContextAddPath(context, path);
	CGContextSetLineWidth(context, 3.0f);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor);
	CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 0.0f, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.1f].CGColor);
	CGContextDrawPath(context, kCGPathStroke);
	
}

@end

@implementation VXAlertTextFieldBack

- (instancetype)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	/*
	 CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	[[UIColor whiteColor] set];
	CGRect backgroundRect = CGRectMake(rect.origin.x+1.0f, rect.origin.y+1.0f, rect.size.width-2.0f, rect.size.height-3.0f);
	
	NSArray* colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0.54 alpha:1.0].CGColor, [UIColor whiteColor].CGColor, [UIColor whiteColor].CGColor,nil];
	CGFloat locations[3] = {0.0, 0.10, 1.0};
	
	CGGradientRef gradient = CGGradientCreateWithColors(CGColorGetColorSpace([UIColor whiteColor].CGColor), (CFArrayRef)colors, locations);
	
	CGContextClipToRect(context, backgroundRect);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(backgroundRect.origin.x, backgroundRect.origin.y), CGPointMake(backgroundRect.origin.x, CGRectGetMaxY(backgroundRect)), 0);
	
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);
	
	[[UIColor blackColor] set];
	
	UIRectFill(CGRectMake(rect.origin.x, rect.origin.y, 1.0f, rect.size.height));
	UIRectFill(CGRectMake(CGRectGetMaxX(rect)-1.0f, rect.origin.y, 1.0f, rect.size.height));
	
	UIRectFill(CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 1.0f));
	UIRectFill(CGRectMake(rect.origin.x, CGRectGetMaxY(rect)-2.0f, rect.size.width, 1.0f));
	
	[[[UIColor whiteColor] colorWithAlphaComponent:0.2] set];
	UIRectFill(CGRectMake(rect.origin.x, CGRectGetMaxY(rect)-1.0f, rect.size.width, 1.0f));
	
	*/
}

@end

