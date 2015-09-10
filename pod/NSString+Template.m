//
//  NSString+Template.m
//  iTheorie
//
//  Created by Graham Lancashire on 19.10.12.
//  Copyright (c) 2012 Swift Management AG. All rights reserved.
//

#import "NSString+Template.h"

@implementation NSString (Template)

+ (NSString * )stringWithTemplate:(NSString*)pTemplate withDictionary:(NSDictionary*)pDictionary {
    NSString* result = nil;
	
    NSMutableString* buffer = [NSMutableString new];
    NSScanner* scanner = [[NSScanner alloc] initWithString:pTemplate];
	scanner.charactersToBeSkipped = nil;
    NSString* tempString = nil;
    
    while([scanner scanUpToString:@"$[" intoString:&tempString]) {
        NSString *key = nil, *value = nil;
        
        [buffer appendString:tempString];
		
        if([scanner isAtEnd]) {
            break;
        }
        NSString *pre, *post; 
        [scanner scanString:@"$[" intoString:&pre];
        [scanner scanUpToString:@"]" intoString:&key];
        [scanner scanString:@"]" intoString:&post];
        
        if(key) {
            value = pDictionary[key];
        }
        
        if(value) {
            [buffer appendString:value];
        } else {
            [buffer appendFormat:@"$[%@]", key];
        }
    }
    
    result = [NSString stringWithString:buffer];
    
    return result;
}

@end
