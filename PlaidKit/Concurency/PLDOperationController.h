//
//  PLDOperationController.h
//  PlaidKit
//
//  Created by Kevin Coleman on 1/28/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h> 
#import "PLDServiceManager.h"
#import "PLDFetchInstitutionsOperation.h"
#import "PLDPersistTransactionsOperation.h"
#import "PLDPersistAccountsOperation.h"
#import "PLDPersistInstitutionsOperation.h"
#import "PLDFetchTransactionsOperation.h"
#import "PLDAuthenticationOperation.h"
#import "PLDFetchCategoriesOperation.h"
#import "PLDPersistCategoriesOperation.h"
#import "PLDFetchAccountsOperation.h"
#import "PLDFetchTransactionsOperation.h"


@interface PLDOperationController : NSObject

+ (instancetype)controllerWithServiceManager:(PLDServiceManager *)serviceManager context:(NSManagedObjectContext *)context;

- (PLDFetchTransactionsOperation *)fetchTransactionsForAccessToken:(NSString *)accessToken
                                                        completion:(void(^)(void))completion;

- (PLDPersistTransactionsOperation *)persistTransactionData:(NSDictionary *)data
                                                 completion:(void(^)(void))completion;

- (PLDFetchAccountsOperation *)fetchAccountsWithCompletion:(void(^)(void))completion;

- (PLDPersistAccountsOperation *)persistAccountData:(NSDictionary *)data
                                         completion:(void(^)(void))completion;

- (PLDFetchInstitutionsOperation *)fetchInstitutionsWithCompletion:(void(^)(void))completion;

- (PLDPersistInstitutionsOperation *)persistInstitutionData:(NSDictionary *)data
                                                 completion:(void(^)(void))completion;

- (PLDFetchCategoriesOperation *)fetchCategoriesWithCompletion:(void(^)(void))completion;

- (PLDPersistCategoriesOperation *)persistCategoryData:(NSDictionary *)data
                                            completion:(void(^)(void))completion;
@end
