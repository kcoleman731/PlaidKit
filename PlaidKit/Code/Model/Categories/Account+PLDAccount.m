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

static NSString *const PLDAccountIdentifier = @"Account";

+ (instancetype)initWithAccountData:(NSDictionary *)accountData context:(NSManagedObjectContext *)context
{
    Account *account = [NSEntityDescription insertNewObjectForEntityForName:PLDAccountIdentifier inManagedObjectContext:context];
    if(account) {
        account.identifier = accountData[PLDAccountIdentifierKey];
        account.item = accountData[PLDAccountItemKey];
        account.institutionType = accountData[PLDInstitutionTypeKey];
        account.type = accountData[PLDAccountTypeKey];
        account.balance = [Balance initWithBalaceData:accountData[PLDAccountBalanceKey] withContect:context];
    }
    return account;
}

+ (Account *)instanceWithIdentifier:(NSString *)identifier
               managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
{
    if (![self checkForExistingEntity:PLDAccountIdentifier withIdentifier:identifier andContext:managedObjectContext]) {
        return [NSEntityDescription insertNewObjectForEntityForName:PLDAccountIdentifier inManagedObjectContext:managedObjectContext];
    }
    return nil;
}

@end
