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

/**
 *  Initializes the Plaid SDK with a client ID and secret.
 *
 *  @param clientID A client ID obtained from the Plaid developer portal
 *  @param secret   A secret obtained from the Plaid developer portal
 *  @discussion The PlaidKit SDK uses a private shared singleton instance which maintains Plaid API credentials . All `Plaid` class methods are routed through this shared instance. PlaidKit leverages core data to provide persistence of data obtained via the Plaid REST API and exposes convinece methods for retreiving this data.
 */
+ (void)sharedInstanceWithClienID:(NSString *)clientID
                           secret:(NSString *)secret;

//-------------------------
//  @name Credentials
//-------------------------

/**
 *  The Plaid client ID supplied upon initailization.
 *
 *  @return An `NSString` object representing the client ID
 */
+ (NSString *)clientID;

/**
 *  The Plaid client secret supplied upon initailization.
 *
 *  @return An `NSString` representing the secret
 */
+ (NSString *)secret;

//-------------------------
//  @name Connect
//-------------------------

/**
 *  Connects A users account via a call to the `/connect` endpoint of the Plaid REST API.
 *
 *  @param account    A `PLDAccount` object containing information about the account that is to be connected.
 *  @param completion A completion block to be called upon completion of the operation. The block has no return value and takes two arguments: A `PLDAuthentication` item containg information about a multi-factor authentication request if necessary, and an error object. Applications can inspect the `authenticationItem` to obtain information about the multi-factor auth challenge and the answer that must be supplied.
 */
+ (void)connectAccount:(PLDAccount *)account
            completion:(void(^)(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error))completion;

//-------------------------
//  @name Auth
//-------------------------

/**
 *  Authenticates a users account via a call to the `/auth` endpoint of the Plaid REST API.
 *
 *  @param account    A `PLDAccount` object containing information about the account that is to be authenticated.
 *  @param completion A completion block to be called upon completion of the operation. The block has no return value and takes two arguments: A `PLDAuthentication` item containg information about a multi-factor authentication request if necessary, and an error object. Applications can inspect the `authenticationItem` to obtain information about the multi-factor auth challenge and the answer that must be supplied.
 */
+ (void)authenticateAccount:(PLDAccount *)account
                 completion:(void(^)(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error))completion;

/**
 *  Completes a multi-factor authentication procedure by supplying the necessary value, either a code or an answer to a question.
 *
 *  @param item      The `PLDAuthenticationItem` supplied via a call to the completion block of `connectAccount:completion` or `authenticateAccount:completion:`. The item must contain a value for the `answer` property.
 *  @param competion A completion block to be called upon completion of the operation. The block has no return value and takes two arguments: A boolean succes value which indicates whether or not the operation was succesful, and an error object.
 */
+ (void)completeAuthenticationWithItem:(PLDAuthenticationItem *)item
                            completion:(void(^)(BOOL success, NSError *error))competion;

+ (void)deauthenticateWithCompletion:(void(^)(BOOL success, NSError *error))completion;

+ (void)deleteAccountWithCompletion:(void(^)(BOOL success, NSError *error))completion;

//-------------------------
//  @name Accounts
//-------------------------

/**
 *  Perfroms a fetch for all existing `Acccount` objects persisted to the local core data store.
 *
 *  @return An `NSArray` of `Account` objects or `nil` if none exist.
 */
+ (NSArray *)allAccounts;

//-------------------------
//  @name Transactions
//-------------------------

/**
 *  Perfroms a fetch for all existing `Transaction` objects persisted to the local core data store.
 *
 *  @param account an `Account` object to which the transactions belog.
 *
 *  @return A `NSArray` of `Transaction` object belonging to the supplied `Account` object.
 */
+ (NSArray *)transactionForAccount:(Account *)account;

//-------------------------
//  @name Categories
//-------------------------

/**
 *  Performs a fetch for all existing `Category` objects persisted to the local core data store.
 *
 *  @return An `NSArray` of `Category` objects or `nil` if none exist.
 *  @discussion Upon initialization, the PlaidKit SDK will fetch all transaction categories via a call to the Plaid REST API `/categories` endpoint. All category data will then be persisted locally and modeled via the `P_Category` object.
 */
+ (NSArray *)allCategories;

//-------------------------
//  @name Institutions
//-------------------------

/**
 *  Performs a fetch for all existing `Institutions` objects persisted to the local core data store.
 *
 *  @return An `NSArray` of `Institution` objects or `nil` if none exist.
 *  @discussion Upon initialization, the PlaidKit SDK will fetch all Institutions via a call to the Plaid REST API `/institutions` endpoint. All institution data will then be persisted locally and modeled via the `Institution` object.
 */
+ (NSArray *)allInstitutions;

@end
