//
//  P_Category+PLDCategory.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/5/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "P_Category+PLDCategory.h"

NSString *const PLDCategoryTypeKey = @"type";
NSString *const PLDCategoryIdentifierKey = @"id";

/*
 {
 "type": "special",
 "hierarchy": [
 "Bank Fees"
 ],
 "id": "10000000"
 },
 */
@implementation P_Category (PLDCategory)

NSString * PLDCategoryEntityName = @"P_Category";

+ (P_Category *)categoryWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context;
{
    P_Category *category = [self instanceWithIdentifier:data[PLDCategoryIdentifierKey] managedObjectContext:context];
    if (category) {
        category.identifier = data[PLDCategoryIdentifierKey];
        category.type = data[PLDCategoryTypeKey];
    }
    return category;
}

+ (P_Category *)instanceWithIdentifier:(NSString *)identifier
                   managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
{
    if (![self checkForExistingEntity:PLDCategoryEntityName withIdentifier:identifier andContext:managedObjectContext]) {
        return [NSEntityDescription insertNewObjectForEntityForName:PLDCategoryEntityName inManagedObjectContext:managedObjectContext];
    }
    return nil;
}

@end
