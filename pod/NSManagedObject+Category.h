//
//  NSManagedObject+isNew.h
//  iTheorie
//
//  Created by Graham Lancashire on 27.10.09.
//  Copyright 2009 Swift Management AG. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (IsNew)

@property (NS_NONATOMIC_IOSONLY, getter=isNew, readonly) BOOL new;

@end

