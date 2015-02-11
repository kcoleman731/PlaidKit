//
//  PLDInstitution.m
//  PlaidKit
//
//  Created by Kevin Coleman on 1/25/15.
//  Copyright (c) 2015 Mercambia. All rights reserved.
//

#import "PLDUtilities.h"

// Request Constants
NSString *const PLDClientIDKey = @"client_id";
NSString *const PLDSecretKey = @"secret";
NSString *const PLDInstitutionTypeKey = @"type";
NSString *const PLDUsernameKey = @"username";
NSString *const PLDPasswordKey = @"password";
NSString *const PLDOptionsKey = @"options";
NSString *const PLDMFAKey = @"mfa";
NSString *const PLDUpgradeKey = @"upgrade_to";

NSString *const PLDClientID = @"54b6b3e9d6c6ee9c0a5d428d";
NSString *const PLDSecret = @"dfcf176c3b4276f34e7b7007bb6123";

NSString *const PLDTestClientID = @"test_id";
NSString *const PLDTestSecret = @"test_secret";

// Response Constants
NSString *const PLDAccesTokenKey = @"access_token";
NSString *const PLDAccountsKey = @"accounts";
NSString *const PLDTransactionsKey = @"transactions";

//NSString *const PLDAccountIdentifierKey = @"_id";
//NSString *const PLDAccountItemKey = @"_item";
//NSString *const PLDAccountBalanceKey = @"balance";
//NSString *const PLDInstitutionTypeKey = @"institution_type";
//NSString *const PLDAccountTypeKey = @"type";


NSString *PLDMFAWithType(PLDMultifactorAuthType mutifactorType)
{
    switch (mutifactorType) {
        case PLDMultifactorAuthTypeQuetion:
            return @"question";
            break;
        
        case PLDMultifactorAuthTypeCode:
            return @"code";
            break;
       
        default:
            break;
    }
    return nil;
}

NSString *PLDProductWithType(PLDProductType productType)
{
    switch (productType) {
        case PLDProductTypeAuth:
            return @"auth";
            break;
        
        case PLDProductTypeConnect:
            return @"connect";
            break;
        
        default:
            break;
    }
    return nil;
}
