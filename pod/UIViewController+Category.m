//
//  UIViewController+Category.h
//  iTheorie
//
//  Created by Graham Lancashire on 07.12.11.
//  Copyright (c) 2011 Swift Management AG. All rights reserved.
//

#import "UIViewController+Category.h"
#import "UIFont+Category.h"

@implementation UIViewController (CompatibleParentController)
- (UIViewController *)compatibleParentController {
    if([self respondsToSelector:@selector(presentingViewController)]) {
        return [self presentingViewController];
    } else {
        return [self parentViewController];
    }
}
// Set to default font
-(void)setFont {
	[self setFontFamily:nil inView:self.view];
}
-(void)setFontFamily:(NSString*) pFontFamily {
	[self setFontFamily:pFontFamily inView:self.view];
}

-(void)setFontFamily:(NSString*)pFontFamily inView:(UIView*)pView {
	for(UIView *subview in pView.subviews) {
		if([subview isKindOfClass:[UILabel class]]) {
			UILabel *label =((UILabel*)subview);
			if(pFontFamily == nil) {
				pFontFamily = kFont;
			}
			
			NSString *fontName = pFontFamily;
			
			int currentSize = label.font.pointSize;
			NSString* currentFontName = label.font.fontName;
			
			
			if([currentFontName hasSuffix:@"-Bold"]) {
				fontName = [fontName stringByAppendingString:@"-Bold"];
			}
				
			UIFont *font =  [UIFont fontWithName:fontName size:currentSize];
			
			if(font != nil) {
				[label setFont:font];
			}
		} else if([subview isKindOfClass:[UITextView class]]) {
			UITextView *textView =((UITextView*)subview);
			if(pFontFamily == nil) {
				pFontFamily = kFont;
			}
			
			NSString *fontName = pFontFamily;
			
			int currentSize = textView.font.pointSize;
			NSString* currentFontName = textView.font.fontName;
			
			
			if([currentFontName hasSuffix:@"-Bold"]) {
				fontName = [fontName stringByAppendingString:@"-Bold"];
			}
			
			UIFont *font =  [UIFont fontWithName:fontName size:currentSize];
			
			if(font != nil) {
				[textView setFont:font];
			}
		} else if([subview isKindOfClass:[UISegmentedControl class]]) {
			UISegmentedControl *segmentControl =((UISegmentedControl*)subview);
			if(pFontFamily == nil) {
				pFontFamily = kFont;
			}
			
			NSString *fontName = pFontFamily;
			fontName = [fontName stringByAppendingString:@"-Bold"];
			
			int currentSize = 12.0f; // segmentControl.font.pointSize;
/*			NSString* currentFontName = segmentControl.font.fontName;
			
			if([currentFontName hasSuffix:@"-Bold"]) {
				fontName = [fontName stringByAppendingString:@"-Bold"];
			}
*/
			UIFont *font =  [UIFont fontWithName:fontName size:currentSize];
			
			if(font != nil) {
				NSDictionary *attributes = @{NSFontAttributeName: font};
				[segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
			}
		} else if([subview isKindOfClass:[UITextField class]]) {
			UITextField *textField =((UITextField*)subview);
			if(pFontFamily == nil) {
				pFontFamily = kFont;
			}
			
			NSString *fontName = pFontFamily;
			
			int currentSize = textField.font.pointSize;
			NSString* currentFontName = textField.font.fontName;
			
			
			if([currentFontName hasSuffix:@"-Bold"]) {
				fontName = [fontName stringByAppendingString:@"-Bold"];
			}
			
			UIFont *font =  [UIFont fontWithName:fontName size:currentSize];
			
			if(font != nil) {
				[textField setFont:font];
			}
		} else {
			[self setFontFamily:pFontFamily inView:subview];
		}
		
	}
}


@end
