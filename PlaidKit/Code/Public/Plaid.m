//
//  PlaidKit.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/3/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Plaid.h"
#import "PLDServiceManager.h"
#import "PLDOperationController.h"
#import "CoreDataStack.h"
#import "Institution+PLDInstitution.h"
#import "P_Category+PLDCategory.h"
#import "PLDAuthenticationItem.h"

@interface Plaid ()

@property (nonatomic) PLDOperationController *operationController;
@property (nonatomic) PLDServiceManager *serviceManager;
@property (nonatomic, readwrite) NSString *secret;
@property (nonatomic, readwrite) NSString *clientID;
@property (nonatomic) CoreDataStack *coreDataStack;

@end

@implementation Plaid

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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Plaid" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    CoreDataStack *coreDataStack = [CoreDataStack stackWithManagedObjectModel:managedObjectModel];
    [[self sharedInstance] setCoreDataStack:coreDataStack];
    
    // Setup Plaid Service Manager
    NSURL *baseURL = [NSURL URLWithString:@"https://tartan.plaid.com/"];
    PLDServiceManager *service = [PLDServiceManager initWithBaseURL:baseURL];
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

- (NSOrderedSet *)transactionForAccount:(Account *)account
{
    return nil;
}

+ (NSArray *)categories
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

+ (NSArray *)institutions
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

#pragma mark - Initial Fetch Methods

- (void)fetchPlaidInstitutionData
{
    __block PLDFetchInstitutionsOperation *operation;
    operation = [self.operationController fetchInstitutionsWithCompletion:^{
        if (operation.institutions) {
            [self.operationController persistInstitutionData:operation.institutions completion:^{
                NSLog(@"Institutions Persisted");
            }];
        } else {
            NSLog(@"Error fetching institutions %@", operation.error);
        }
    }];
}
- (void)fetchPlaidCategoryData
{
    __block PLDFetchCategoriesOperation *operation;
    operation = [self.operationController fetchCategoriesWithCompletion:^{
        if (operation.categoryData) {
            [self.operationController persistCategoryData:operation.categoryData completion:^{
                NSLog(@"Categories Persisted");
            }];
        } else {
            NSLog(@"Error fetching categories");
        }
    }];
}

+ (NSString *)secret
{
    return [[self sharedInstance] secret];
}

+ (NSString *)clientID
{
    return  [[self sharedInstance] clientID];
}

#pragma mark - Connection Methods 

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

- (PLDAuthenticationItem *)authenticationChallengeForResponseData:(NSDictionary *)responseData
{
    return [PLDAuthenticationItem new];
}

- (void)fetchTransactionsForAccessToken:(NSString *)accessToken;
{
    __block PLDFetchTransactionsOperation *operation;
    operation = [self.operationController fetchTransactionsForAccessToken:accessToken completion:^{
        if (operation.transactionData) {
            PLDPersistTransactionsOperation *persistOperation = [self.operationController persistTransactionData:operation.transactionData completion:^{
                // Hanlde Failed Transaction Persist
            }];
        } else {
            // Hanlde Failed Transaction Fetch
        }
    }];
}

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
