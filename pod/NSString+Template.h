//
//  NSString+Template.h
//  iTheorie
//
//  Created by Graham Lancashire on 19.10.12.
//  Copyright (c) 2012 Swift Management AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/*   
 NSString* template = @"Hello $[name], welcome to $[city].";
 NSString* string = [NSString stringWithTemplate:testTemplate
						fromMap:[NSDictionary dictionaryWithObjectsAndKeys:
							  @"Popcorny", @"name"
							  @"Taipei", @"city",
							  nil]];
*/

@interface NSString (Template)

+ (NSString * )stringWithTemplate:(NSString*)pTemplate withDictionary:(NSDictionary*)pDictionary ;

@end
