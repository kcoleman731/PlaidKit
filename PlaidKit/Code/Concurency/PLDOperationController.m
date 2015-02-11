//
//  PLDOperationController.m
//  PlaidKit
//
//  Created by Kevin Coleman on 1/28/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDOperationController.h"
@interface PLDOperationController ()

@property (nonatomic) PLDServiceManager *serviceManager;
@property (nonatomic) NSOperationQueue *operationQueue;
@property (nonatomic) NSManagedObjectContext *persistenceContext;

@end

@implementation PLDOperationController

NSString *const PLDOperationQueueName = @"PLDOperationQueue";

NSString *const PLDTestUsername = @"plaid_test";
NSString *const PLDTestMFAUsername = @"plaid_selections";
NSString *const PLDTestPassword = @"plaid_good";
NSString *const PLDTestFakePassword = @"plaid_bad";
NSString *const PLDTestPin = @"1234";
NSString *const PLDTestAccessToken = @"test";

+ (instancetype)controllerWithServiceManager:(PLDServiceManager *)serviceManager context:(NSManagedObjectContext *)context
{
    return [[super alloc] initWithServiceManager:serviceManager context:context];
}

- (id)initWithServiceManager:(PLDServiceManager *)serviceManager context:(NSManagedObjectContext *)context
{
    self = [super init];
    if (self) {
        
        _serviceManager = serviceManager;
        
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.name = PLDOperationQueueName;
        _operationQueue.maxConcurrentOperationCount = 1;

        _persistenceContext = context;
    }
    return self;
}

- (PLDFetchTransactionsOperation *)fetchTransactionsForAccessToken:(NSString *)accessToken
                                                        completion:(void(^)(void))completion
{
    PLDFetchTransactionsOperation *operation = [[PLDFetchTransactionsOperation alloc] initWithAccessToken:accessToken];
    [self addOperation:operation completion:completion];
    return operation;
}

- (PLDPersistTransactionsOperation *)persistTransactionData:(NSDictionary *)data
                    completion:(void(^)(void))completion;
{
    PLDPersistTransactionsOperation *operation = [[PLDPersistTransactionsOperation alloc] initWithTransactionData:data];
    [self addOperation:operation completion:completion];
    return operation;
}

- (PLDFetchAccountsOperation *)fetchAccountsWithCompletion:(void(^)(void))completion
{
    return nil;
}

- (PLDPersistAccountsOperation *)persistAccountData:(NSDictionary *)data
                completion:(void(^)(void))completion
{
    PLDPersistAccountsOperation *operation = [[PLDPersistAccountsOperation alloc] initWithAccountData:data];
    [self addOperation:operation completion:completion];
    return operation;
}

- (PLDFetchInstitutionsOperation *)fetchInstitutionsWithCompletion:(void(^)(void))completion
{
    PLDFetchInstitutionsOperation *operation = [[PLDFetchInstitutionsOperation alloc] init];
    [self addOperation:operation completion:completion];
    return operation;
}

- (PLDPersistInstitutionsOperation *)persistInstitutionData:(NSDictionary *)data completion:(void (^)(void))completion
{
    PLDPersistInstitutionsOperation *operation = [[PLDPersistInstitutionsOperation alloc] initWithInstitutionData:data];
    [self addOperation:operation completion:completion];
    return operation;
}

- (PLDFetchCategoriesOperation *)fetchCategoriesWithCompletion:(void(^)(void))completion
{
    PLDFetchCategoriesOperation *operation = [[PLDFetchCategoriesOperation alloc] init];
    [self addOperation:operation completion:completion];
    return operation;
}

- (PLDPersistCategoriesOperation *)persistCategoryData:(NSDictionary *)data completion:(void(^)(void))completion
{
    PLDPersistCategoriesOperation *operation = [[PLDPersistCategoriesOperation alloc] initWithCategoryData:data];
    [self addOperation:operation completion:completion];
    return operation;
}

- (void)addOperation:(PLDOperation *)operation completion:(id)completion
{
    operation.context = self.persistenceContext;
    operation.serviceManager = self.serviceManager;
    if (completion) operation.completionBlock = completion;
    [self.operationQueue addOperation:operation];
}

@end
