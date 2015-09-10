//
//  NSManagedObjectContext.m
//  iTheorie
//
//  Created by Graham Lancashire on 10.12.09.
//  Copyright 2009 Swift Management AG. All rights reserved.
//

#import "NSManagedObjectContext+Category.h"


@implementation NSManagedObjectContext (Category)



// Convenience method to fetch the array of objects for a given Entity
// name in the context, optionally limiting by a predicate or by a predicate
// made from a format NSString and variable arguments.
//
- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName
					   withPredicate:(id)stringOrPredicate, ...
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:newEntityName inManagedObjectContext:self];
	
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    if (stringOrPredicate)
    {
        NSPredicate *predicate;
        if ([stringOrPredicate isKindOfClass:[NSString class]])
        {
            va_list variadicArguments;
            va_start(variadicArguments, stringOrPredicate);
            predicate = [NSPredicate predicateWithFormat:stringOrPredicate
											   arguments:variadicArguments];
            va_end(variadicArguments);
        }
        else
        {
            //NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]], @"Second parameter passed to %s is of unexpected class %@", sel_getName(_cmd), [stringOrPredicate className]);
            predicate = (NSPredicate *)stringOrPredicate;
        }
        [request setPredicate:predicate];
    }
	
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (error != nil)
    {
        [NSException raise:NSGenericException format:@"%@", [error description]];
    }
    
    return [NSSet setWithArray:results];
}
- (NSManagedObject *)objectWithURI:(NSURL *)uri
{
    NSManagedObjectID *objectID =	[[self persistentStoreCoordinator]	 managedObjectIDForURIRepresentation:uri];
    
    if (!objectID)
    {
        return nil;
    }
    
	NSManagedObject *objectForID = objectID ? [self objectRegisteredForID:objectID] : nil; 

    if (objectForID)
    {
        return objectForID;
    }
	
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[objectID entity]];
    
    // Equivalent to
    // predicate = 
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF == %@", objectID];
	[request setPredicate:predicate];
	
    NSArray *results = [self executeFetchRequest:request error:nil];
    if ([results count] > 0 )
    {
        return results[0];
    }
	
    return nil;
}
@end
