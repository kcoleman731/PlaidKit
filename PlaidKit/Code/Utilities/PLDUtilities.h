//
//  PLDInstitution.h
//  PlaidKit
//
//  Created by Kevin Coleman on 1/25/15.
//  Copyright (c) 2015 Mercambia. All rights reserved.
//

#import <Foundation/Foundation.h>

// Request Constants
NSString *const PLDClientIDKey;
NSString *const PLDSecretKey;
NSString *const PLDInstitutionTypeKey;
NSString *const PLDUsernameKey;
NSString *const PLDPasswordKey;
NSString *const PLDOptionsKey;
NSString *const PLDMFAKey;
NSString *const PLDUpgradeKey;

NSString *const PLDAccesTokenKey;
NSString *const PLDAccountsKey;
NSString *const PLDTransactionsKey;

NSString *const PLDClientID;
NSString *const PLDSecret;

NSString *const PLDTestClientID;
NSString *const PLDTestSecret;

typedef NS_ENUM(NSUInteger, PLDMultifactorAuthType) {
    PLDMultifactorAuthTypeQuetion,
    PLDMultifactorAuthTypeCode
};

typedef NS_ENUM(NSUInteger, PLDProductType) {
    PLDProductTypeAuth,
    PLDProductTypeConnect,
};

NSString *PLDMFAWithType(PLDMultifactorAuthType mutifactorType);

NSString *PLDProductWithType(PLDProductType productType);



