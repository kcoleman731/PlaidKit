//
//  Account+PLDAccount.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/2/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Account.h"
#import "NSManagedObject+PLDManagedObject.h"

typedef NS_ENUM(NSUInteger, PLDAccountType) {
    PLDAccountTypeDepository,
    PLDAccountTypeCredit,
};

extern NSString *const PLDAccountIdentifierKey;
extern NSString *const PLDAccountItemKey;
extern NSString *const PLDAccountBalanceKey;
extern NSString *const PLDInstitutionTypeKey;
extern NSString *const PLDAccountTypeKey;
extern NSString *const PLDAccountBalaceKey;

@interface Account (PLDAccount)

+ (instancetype)initWithAccountData:(NSDictionary *)accountData context:(NSManagedObjectContext *)context;

@end
