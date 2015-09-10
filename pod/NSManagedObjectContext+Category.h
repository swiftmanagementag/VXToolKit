//
//  NSManagedObjectContext.h
//  iTheorie
//
//  Created by Graham Lancashire on 10.12.09.
//  Copyright 2009 Swift Management AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Category)

/*
 [[self managedObjectContext] fetchObjectsForEntityName:@"Employee" withPredicate:
 @"(lastName LIKE[c] 'Worsley') AND (salary > %@)", minimumSalary];
 */

- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName withPredicate:(id)stringOrPredicate, ...;
- (NSManagedObject *)objectWithURI:(NSURL *)uri;

@end
