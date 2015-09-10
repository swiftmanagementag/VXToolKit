//
//  VXConfiguration.h
//  
//
//  Created by Graham Lancashire on 25.10.12.
//
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kVXScreenWidth (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 768.0f :  320.0f)
#define kVXTableRowHeight (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 92.0f :  46.0f)
#define kVXTableSectionHeight (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 30.0f :  21.0f)
#define kVXTableFontSize (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 30.0f :  16.0f)
#define kVXTableFontSmallSize (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 16.0f :  12.0f)
#define kVXTabFontSize (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 14.0f :  9.0f)
#define kVXWebFontSize (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 24.0f :  16.0f)
#define kVXBadgeWidth (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 80.0f :  36.0f)
#define kVXMargin (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 20.0f :  12.0f)
#define kVXTableIcon (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 56.0f :  22.0f)
#define kVXSegmentHeight (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 30.0f :  30.0f)
#define kVXSegmentWidth (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 40.0f :  40.0f)

@interface VXConfiguration : NSObject
+ (NSString *)getVersionShort;
+ (NSString *)getVersion;
+ (NSString *) getNib:(NSString *)pNib;

@end
