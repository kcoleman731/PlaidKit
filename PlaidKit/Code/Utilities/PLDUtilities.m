//
//  PLDInstitution.m
//  PlaidKit
//
//  Created by Kevin Coleman on 1/25/15.
//  Copyright (c) 2015 Mercambia. All rights reserved.
//

#import "PLDUtilities.h"

// Request Constants
NSString *const PKAPIClientIDKey = @"client_id";
NSString *const PKAPISecretKey = @"secret";
NSString *const PKAPIInstitutionTypeKey = @"type";
NSString *const PKAPIUsernameKey = @"username";
NSString *const PKAPIPasswordKey = @"password";
NSString *const PKAPIOptionsKey = @"options";
NSString *const PKAPIMFAKey = @"mfa";
NSString *const PKAPIUpgradeKey = @"upgrade_to";

// Response Constants
NSString *const PKAPIAccesTokenKey = @"access_token";
NSString *const PKAPIAccountsKey = @"accounts";
NSString *const PKAPITransactionsKey = @"transactions";

NSString *const PKAPIClientID = @"54b6b3e9d6c6ee9c0a5d428d";
NSString *const PKAPISecret = @"dfcf176c3b4276f34e7b7007bb6123";

NSString *const PKAPITestClientID = @"test_id";
NSString *const PKAPITestSecret = @"test_secret";

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
