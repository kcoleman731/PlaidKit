//
//  PlaidKit.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/3/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLDUtilities.h"
#import "Institution+PLDInstitution.h"
#import "PLDAuthenticationItem.h"
#import "Account+PLDAccount.h"
#import "PLDAccount.h"

@interface Plaid : NSObject

+ (void)sharedInstanceWithClienID:(NSString *)clientID
                           secret:(NSString *)secret;

+ (NSString *)clientID;

+ (NSString *)secret;

+ (NSArray *)allAccounts;

+ (NSArray *)transactionForAccount:(Account *)account;

+ (NSArray *)categories;

+ (NSArray *)institutions;

+ (void)connectAccount:(PLDAccount *)account
            completion:(void(^)(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error))completion;

+ (void)authenticateAccount:(PLDAccount *)account
                 completion:(void(^)(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error))completion;

+ (void)completeAuthenticationWithItem:(PLDAuthenticationItem *)item
                            completion:(void(^)(BOOL success, NSError *error))competion;

+ (void)deauthenticateWithCompletion:(void(^)(BOOL success, NSError *error))completion;

+ (void)deleteAccountWithCompletion:(void(^)(BOOL success, NSError *error))completion;

@end
