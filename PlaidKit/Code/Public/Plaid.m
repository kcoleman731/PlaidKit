//
//  PlaidKit.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/3/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Plaid.h"
#import <UIKit/UIKit.h>
#import "PLDServiceManager.h"
#import "PLDOperationController.h"
#import "CoreDataStack.h"
#import "Institution+PLDInstitution.h"
#import "P_Category+PLDCategory.h"
#import "PLDAuthenticationItem.h"
#import "Transaction+PLDTransaction.h"

@interface Plaid ()

@property (nonatomic) PLDOperationController *operationController;
@property (nonatomic) PLDServiceManager *serviceManager;
@property (nonatomic, readwrite) NSString *secret;
@property (nonatomic, readwrite) NSString *clientID;
@property (nonatomic) CoreDataStack *coreDataStack;

@end

@implementation Plaid

NSString *const PLDDidPersistedInstitutionsNotification = @"DidPersistedInstitutionsNotification";
NSString *const PLDDidPersistedCategoriesNotification = @"DidPersistedCategoriesNotification";
NSString *const PLDDidPersistedTransactionsNotification = @"DidPersistedTransactionsNotification";
NSString *const PLDDidPersistedAccountNotification = @"DidPersistedAccountNotification";

+ (instancetype)sharedInstance
{
    static Plaid *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[Plaid alloc] init];
    });
    return __instance;
}

+ (void)sharedInstanceWithClienID:(NSString *)clientID secret:(NSString *)secret
{
    [[self sharedInstance] setClientID:clientID];
    [[self sharedInstance] setSecret:secret];
    
    // Initialize Core Data Stack
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PlaidKitResource.bundle/Plaid" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    CoreDataStack *coreDataStack = [CoreDataStack stackWithManagedObjectModel:managedObjectModel];
    [[self sharedInstance] setCoreDataStack:coreDataStack];
    
    // Setup Plaid Service Manager
    //https://tartan.plaid.com/
    NSURL *baseURL = [NSURL URLWithString:@"https://api.plaid.com/"];
    PLDServiceManager *service = [PLDServiceManager initWithBaseURL:baseURL];
    service.clientID = clientID;
    service.secret = secret;
    [[self sharedInstance] setServiceManager:service];
    
    // Setup Operatio Controller
    PLDOperationController *controller = [PLDOperationController controllerWithServiceManager:service context:coreDataStack.persistenceContext];
    [[self sharedInstance] setOperationController:controller];
    
    [[self sharedInstance] registerForNotifications];
    [[self sharedInstance] fetchPlaidInstitutionData];
    [[self sharedInstance] fetchPlaidCategoryData];
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveManagedObjectContextDidSaveNotification:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.coreDataStack.persistenceContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

#pragma mark - Credentials

+ (NSString *)secret
{
    return [[self sharedInstance] secret];
}

+ (NSString *)clientID
{
    return  [[self sharedInstance] clientID];
}

#pragma mark - Connection

+ (void)connectAccount:(PLDAccount *)account
            completion:(void(^)(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error))completion;
{
    [[self sharedInstance] connectAccount:account completion:completion];
}

- (void)connectAccount:(PLDAccount *)account
            completion:(void(^)(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error))completion;
{
    [self.serviceManager connectWithUsername:account.username password:account.password institutionType:account.institutionType success:^(NSDictionary *responseData) {
        if ([responseData valueForKey:PLDAuthenticationItemMFAKey]) {
            PLDAuthenticationItem *item = [PLDAuthenticationItem itemWithResponseData:responseData];
            completion(YES, item, nil);
        } else {
            [self persistAccountData:responseData[@"accounts"]];
            [self persistTransactionData:responseData[@"transactions"]];
            [self persistAccessToken:responseData[@"access_token"] forAccountNumber:responseData[@"accounts"][0]];
            completion(YES, nil, nil);
        }
    } failure:^(NSError *error) {
        completion(NO, nil, error);
    }];
}

#pragma mark - Authentication Methods 

+ (void)authenticateAccount:(PLDAccount *)account
                 completion:(void(^)(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error))completion;
{
    [[self sharedInstance] authenticateAccount:account completion:completion];
}

- (void)authenticateAccount:(PLDAccount *)account
                 completion:(void(^)(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error))completion;
{
    [self.serviceManager authenticateWithUsername:account.username password:account.password institutionType:account.institutionType success:^(NSDictionary *responseData) {
        if ([responseData valueForKey:PLDAuthenticationItemMFAKey]) {
            PLDAuthenticationItem *item = [PLDAuthenticationItem itemWithResponseData:responseData];
            completion(YES, item, nil);
        } else {
            completion(YES, nil, nil);
        }
    } failure:^(NSError *error) {
        completion(NO, nil, error);
    }];
}

#pragma mark - Multi Factor Auth 

+ (void)completeAuthenticationWithItem:(PLDAuthenticationItem *)item
                            completion:(void(^)(BOOL success, NSError *error))competion
{
    [[self sharedInstance] completeAuthenticationWithItem:item completion:competion];
}

- (void)completeAuthenticationWithItem:(PLDAuthenticationItem *)item
                            completion:(void(^)(BOOL success, NSError *error))competion
{
    [self.serviceManager MFAAuthWithAnswer:item.answer accessToken:item.accessToken success:^(NSDictionary *responseData) {
        [self fetchTransactionsForAccessToken:nil];
        competion(YES, nil);
    } failure:^(NSError *error) {
        [self fetchTransactionsForAccessToken:@"test"];
        competion(NO, error);
    }];
}

- (void)fetchTransactionsForAccessToken:(NSString *)accessToken;
{
    __block PLDFetchTransactionsOperation *operation;
    operation = [self.operationController fetchTransactionsForAccessToken:accessToken completion:^{
        if (operation.transactionData) {
            [self persistTransactionData:operation.transactionData];
        }
    }];
}

#pragma mark - Deauthentication 

+ (void)deauthenticateWithCompletion:(void(^)(BOOL success, NSError *error))completion
{
    
}

+ (void)deleteAccountWithCompletion:(void(^)(BOOL success, NSError *error))completion
{
    
}

#pragma mark - Fetch Methods

+ (NSArray *)allAccounts
{
    Plaid *plaid = [self sharedInstance];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:PLDAccountEntityName];
    NSError *error;
    NSArray *accounts = [plaid.coreDataStack.userInterfaceContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Failed fetching insitutions with error %@", error);
    }
    return accounts;
}

+ (NSArray *)transactionForAccount:(Account *)account
{
    Plaid *plaid = [self sharedInstance];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:PLDTransactionEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"SELF.account = %@", account];
    NSError *error;
    NSArray *transactions = [plaid.coreDataStack.userInterfaceContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Failed fetching insitutions with error %@", error);
    }
    return transactions;
}

+ (NSArray *)allCategories
{
    Plaid *plaid = [self sharedInstance];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:PLDCategoryEntityName];
    NSError *error;
    NSArray *categories = [plaid.coreDataStack.userInterfaceContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Failed fetching insitutions with error %@", error);
    }
    return categories;
}

+ (NSArray *)allInstitutions
{
    Plaid *plaid = [self sharedInstance];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:PLDInstitutionEntityName];
    NSError *error;
    NSArray *institutions = [plaid.coreDataStack.userInterfaceContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Failed fetching insitutions with error %@", error);
    }
    return institutions;
}

#pragma mark - Peristence

- (void)persistAccountData:(NSDictionary *)accountData
{
    __block PLDPersistAccountsOperation *operation;
    operation = [self.operationController persistAccountData:accountData completion:^{
        if (operation.error) {
            NSLog(@"Failed persisting transaction data with error: %@", operation.error);
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:PLDDidPersistedAccountNotification object:nil];
            NSLog(@"Transaction Data Persisted");
        }
    }];
}

- (void)persistTransactionData:(NSDictionary *)transactionData
{
    __block PLDPersistTransactionsOperation *operation;
    operation = [self.operationController persistTransactionData:transactionData completion:^{
        if (operation.error) {
            NSLog(@"Failed persisting transaction data with error: %@", operation.error);
        } else {
            NSLog(@"Transaction Data Persisted");
            [[NSNotificationCenter defaultCenter] postNotificationName:PLDDidPersistedTransactionsNotification object:nil];
        }
    }];
}

- (void)persistAccessToken:(NSString *)accessToken forAccountNumber:(NSDictionary *)accountData;
{
    NSString *accountIdentifier = accountData[@"id"];
    [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:accountIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Fetch Methods

- (void)fetchPlaidInstitutionData
{
    if ([Plaid allInstitutions].count) {
        return;
    }
    __block PLDFetchInstitutionsOperation *fetchOperation;
    fetchOperation = [self.operationController fetchInstitutionsWithCompletion:^{
        if (fetchOperation.institutions) {
            __block PLDPersistInstitutionsOperation *persistOperation;
            persistOperation = [self.operationController persistInstitutionData:fetchOperation.institutions completion:^{
                if (!persistOperation.error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:PLDDidPersistedInstitutionsNotification object:nil];
                } else {
                    NSLog(@"Error fetching institutions %@", persistOperation.error);
                }
            }];
        } else {
            NSLog(@"Error fetching institutions %@", fetchOperation.error);
        }
    }];
}
- (void)fetchPlaidCategoryData
{
    if ([Plaid allCategories].count) {
        return;
    }
    __block PLDFetchCategoriesOperation *fetchOperation;
    fetchOperation = [self.operationController fetchCategoriesWithCompletion:^{
        if (fetchOperation.categoryData) {
            __block PLDPersistCategoriesOperation *persistOperation;
            persistOperation = [self.operationController persistCategoryData:fetchOperation.categoryData completion:^{
                if (!persistOperation.error) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:PLDDidPersistedCategoriesNotification object:nil];
                } else {
                    NSLog(@"Error persisting categories %@", persistOperation.error);
                }
            }];
        } else {
            NSLog(@"Error fetching categories");
        }
    }];
}

#pragma mark - Notification Handlers

- (void)didReceiveManagedObjectContextDidSaveNotification:(NSNotification *)notification
{
    [self.coreDataStack.userInterfaceContext performBlock:^{
        [self.coreDataStack.userInterfaceContext mergeChangesFromContextDidSaveNotification:notification];
    }];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [self.coreDataStack saveContexts:nil];
}

@end
