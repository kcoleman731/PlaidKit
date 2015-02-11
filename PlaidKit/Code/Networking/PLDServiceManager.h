//
//  PlaidKit.h
//  PlaidKit
//
//  Created by Kevin Coleman on 1/25/15.
//  Copyright (c) 2015 Mercambia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLDUtilities.h"
#import "Institution+PLDInstitution.h"

@interface PLDServiceManager : NSObject

@property (nonatomic) NSString *clientID;
@property (nonatomic) NSString *secret;

+ (instancetype)initWithBaseURL:(NSURL *)baseURL;

+ (instancetype)sharedService;

//--------------------------
// CONNECT Enpoints
//--------------------------

- (void)connectWithUsername:(NSString *)username
                   password:(NSString *)password
            institutionType:(PLDInstitutionType)institutionType
                    success:(void(^)(NSDictionary *responseData))success
                    failure:(void(^)(NSError *error))failure;

- (void)MFAAuthWithAnswer:(NSString *)answer
              accessToken:(NSString *)accessToken
                  success:(void(^)(NSDictionary *responseData))success
                  failure:(void(^)(NSError *error))failure;

- (void)updateWithUsername:(NSString *)username
                  password:(NSString *)password
               accessToken:(NSString *)accessToken
                   success:(void(^)(NSDictionary *responseData))success
                   failure:(void(^)(NSError *error))failure;

- (void)deleteAccountForAccessToken:(NSString *)accessToken
                            success:(void(^)(NSDictionary *responseData))success
                            failure:(void(^)(NSError *error))failure;

- (void)getTransactionsWithAccessToken:(NSString *)accessToken
                               options:(NSDictionary *)options
                               success:(void(^)(NSDictionary *responseData))success
                               failure:(void(^)(NSError *error))failure;

//--------------------------
// AUTH Enpoints
//--------------------------

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                 institutionType:(PLDInstitutionType)institutionType
                         success:(void(^)(NSDictionary *responseData))success
                         failure:(void(^)(NSError *error))failure;

- (void)accountInformationForAccessToken:(NSString *)accessToken
                                 success:(void(^)(NSDictionary *responseData))success
                                 failure:(void(^)(NSError *error))failure;

//- (void)deleteAccountForAccessToken:(NSString *)accessToken
//                            success:(void(^)(NSDictionary *responseData))success
//                            failure:(void(^)(NSError *error))failure;

//--------------------------
// BALANCE Enpoints
//--------------------------

- (void)accountBalanceWithAccessToken:(NSString *)accessToken
                              success:(void(^)(NSDictionary *responseData))success
                              failure:(void(^)(NSError *error))failure;


//--------------------------
// UPGRADE Enpoints
//--------------------------

- (void)upgrateAccountWithAccessToken:(NSString *)accessToken
                        toProductType:(PLDProductType)productType
                              success:(void(^)(NSDictionary *responseData))success
                              failure:(void(^)(NSError *error))failure;

//--------------------------
// Institution Enpoints
//--------------------------

- (void)institutionsWithSuccess:(void(^)(NSDictionary *responseData))success
                        failure:(void(^)(NSError *error))failure;

//--------------------------
// Categories Enpoints
//--------------------------

- (void)categoriesWithSuccess:(void(^)(NSDictionary *responseData))success
                      failure:(void(^)(NSError *error))failure;

@end
