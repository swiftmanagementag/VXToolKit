//
//  VXAlertView.h
//  VXAlertView.h
//

/* Blocks usage:
[[[VXAlertView alloc] initWithTitle:@"Some Title" message:@"Are you sure you want to do this?" completionBlock:^(NSUInteger buttonIndex) {
	switch (buttonIndex) {
		case 0:
			NSLog(@"Not doing it");
			break;
		case 1:
			NSLog(@"I'm doing it!");
			break;
			break;
	}
} cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil]  show];
*/

#import <UIKit/UIKit.h>

@interface VXAlertView : UIAlertView <UIWebViewDelegate>{

	@private
	NSMutableArray* __textFields; // Single underscore is used in UIAlertView
	BOOL overrodeHeight;
	CGFloat textFieldHeightOffset;
}
@property(nonatomic,readonly) NSInteger numberOfTextFields;
@property(unsafe_unretained, nonatomic,readonly) UITextField* firstTextField;
@property(readwrite, strong) UIWebView* webView;

- (instancetype)initWithMessage:(NSString *)pMessage dismissAfter:(NSTimeInterval)pInterval;
- (instancetype)initWithFile:(NSString *)pFile dismissAfter:(NSTimeInterval)pInterval;
- (instancetype)initWithHtml:(NSString *)pContent dismissAfter:(NSTimeInterval)pInterval NS_DESIGNATED_INITIALIZER;
- (void)close;

- (void)addTextField:(UITextField*)textField;
- (UITextField*)addTextFieldWithLabel:(NSString*)label;
- (UITextField*)addTextFieldWithLabel:(NSString*)label value:(NSString*)value;

- (UITextField*)textFieldForIndex:(NSInteger)index;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message completionBlock:(void (^)(NSUInteger buttonIndex))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
