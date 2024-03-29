//
//  NSManagedObject+PLDManagedObject.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/2/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (PLDManagedObject)

+ (BOOL) checkForExistingEntity:(NSString *)entity
                 withIdentifier:(NSString *)identifier
                     andContext:(NSManagedObjectContext *)context;

@end
