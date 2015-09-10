//
//  NSString+Category.h
//  iTheorie
//
//  Created by Graham Lancashire on 29.02.12.
//  Copyright (c) 2012 Swift Management AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
+ (NSString*)base64forData:(NSData*)theData;
+(NSString *)getUUID;
-(BOOL)isValidEmailStrict:(BOOL)pStrictFilter;
@end
