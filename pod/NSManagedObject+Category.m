//
//  NSManagedObject+isNew.m
//  iTheorie
//
//  Created by Graham Lancashire on 27.10.09.
//  Copyright 2009 Swift Management AG. All rights reserved.
//

#import "NSManagedObject+Category.h"


@implementation NSManagedObject(Category)
-(BOOL)isNew 
{
    NSDictionary *vals = [self committedValuesForKeys:nil];
    return [vals count] == 0;
}
@end
