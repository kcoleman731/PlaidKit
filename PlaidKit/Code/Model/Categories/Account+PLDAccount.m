//
//  Account+PLDAccount.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/2/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Account+PLDAccount.h"
#import "PLDUtilities.h"
#import "Balance+PLDBalance.h"

NSString *const PLDAccountIdentifierKey = @"_id";
NSString *const PLDAccountItemKey = @"_item";
NSString *const PLDAccountUserKey = @"_user";
NSString *const PLDAccountBalanceKey = @"balance";
NSString *const PLDAccountInstitutionTypeKey = @"institution_type";
NSString *const PLDAccountMetaKey = @"meta";
NSString *const PLDAccountNameKey = @"name";
NSString *const PLDAccountShortNumberKey = @"number";
NSString *const PLDAccountTypeKey = @"type";

/*
{
    "_id" = mjj9jp92z2fD1mLlpQYZI1gAd4q4LwTKmBNLz;
    "_item" = aWWVW4VqGqIdaP495QyOSVLN1nzjLwhXaPDJJ;
    "_user" = bkkVkMVwQwfYmBMy9jzqHQob9O1KwpFaEyLOE;
    balance =             {
        available = "1203.42";
        current = "1274.93";
    };
    "institution_type" = "fake_institution";
    meta =             {
        name = "Plaid Savings";
        number = 9606;
    };
    type = depository;
},
*/

@implementation Account (PLDAccount)

NSString *const PLDAccountEntityName = @"Account";

+ (instancetype)initWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    Account *account = [self instanceWithIdentifier:data[PLDAccountIdentifierKey] managedObjectContext:context];
    if(account) {
        account.identifier = data[PLDAccountIdentifierKey];
        account.item = data[PLDAccountItemKey];
        account.user = data[PLDAccountUserKey];
        account.balance = [Balance initWithBalaceData:data[PLDAccountBalanceKey] withContect:context];
        account.institutionType = data[PLDInstitutionTypeKey];
        account.name = data[PLDAccountMetaKey][PLDAccountNameKey];
        account.shortNumber = data[PLDAccountMetaKey][PLDAccountShortNumberKey];
        account.type = data[PLDAccountTypeKey];
    }
    return account;
}

+ (Account *)instanceWithIdentifier:(NSString *)identifier
               managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
{
    if (![self checkForExistingEntity:PLDAccountEntityName withIdentifier:identifier andContext:managedObjectContext]) {
        return [NSEntityDescription insertNewObjectForEntityForName:PLDAccountEntityName inManagedObjectContext:managedObjectContext];
    }
    return nil;
}

@end
