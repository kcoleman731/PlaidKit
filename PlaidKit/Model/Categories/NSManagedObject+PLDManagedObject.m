//
//  NSManagedObject+PLDManagedObject.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/2/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "NSManagedObject+PLDManagedObject.h"

@implementation NSManagedObject (PLDManagedObject)

+ (BOOL) checkForExistingEntity:(NSString *)entity
                 withIdentifier:(NSString *)identifier
                     andContext:(NSManagedObjectContext *)context;
{
    //First check to see if the message exists
    NSFetchRequest *request =  [NSFetchRequest fetchRequestWithEntityName:entity];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if (!objects || objects.count > 1) {
        //If there was an error with the fetch
        NSLog(@"Error with core data");
        return TRUE;
    } else if (objects.count == 0) {
        //No message exists, create it
        return FALSE;
    } else {
        //Message already exists
        NSLog(@"Venue already exists, do nothing");
        return TRUE;
    }
    return TRUE;
}

@end
