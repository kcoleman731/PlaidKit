//
//  PlaidTest.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/5/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Plaid.h"
#import "PLDTestUtilities.h"
#import <Expecta/Expecta.h>

@interface PlaidTest : XCTestCase

@property (nonatomic) BOOL fullfilled;
@end

@implementation PlaidTest

- (void)setUp
{
    [super setUp];
    [Expecta setAsynchronousTestTimeout:10];
    [Plaid sharedInstanceWithClienID:PLDTestClientID secret:PLDTestSecret];
    self.fullfilled = NO;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testToVerifyClientID
{
    expect([Plaid clientID]).to.equal(PLDTestClientID);
}

- (void)testToVerifyClientSecret
{
    expect([Plaid secret]).to.equal(PLDTestSecret);
}

- (void)testToVerifyInstitutionsPersisted
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Institutions To Be Persisted"];
    [[NSNotificationCenter defaultCenter] addObserverForName:PLDDidPersistedInstitutionsNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                          NSArray *insitutions = [Plaid allInstitutions];
                                                          expect(insitutions).toNot.beNil;
                                                          if (!self.fullfilled) {
                                                              [expectation fulfill];
                                                              self.fullfilled = YES;
                                                          } else {
                                                             
                                                          }
                                                      });
    }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testToVerifyCategoriesPersisted
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Categories To Be Persisted"];
    [[NSNotificationCenter defaultCenter] addObserverForName:PLDDidPersistedCategoriesNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                          NSArray *catagories = [Plaid allCategories];
                                                          expect(catagories).toNot.beNil;
                                                          if (!self.fullfilled) {
                                                              [expectation fulfill];
                                                              self.fullfilled = YES;
                                                          } else {
                                                          }
                                                      });
                                                  }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testToVerifyAuthWithMFA
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Auth Verification"];
    
    PLDAccount *account = [PLDAccount accountWithInstitutionType:PLDInstitutionTypeBankOfAmerica];
    account.username = PLDTestUsername;
    account.password = PLDTestPassword;
    
    [Plaid authenticateAccount:account completion:^(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error) {
        authenticationItem.answer = @"Tomato";
        [Plaid completeAuthenticationWithItem:authenticationItem completion:^(BOOL success, NSError *error) {
            if (error.code == 1108) {
                if (!self.fullfilled) {
                    [expectation fulfill];
                    self.fullfilled = YES;
                } else {
                }
            }
        }];
    }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testToVerifyAuthWithoutMFA
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Auth w/ MFA Verification"];
    
    PLDAccount *account = [PLDAccount accountWithInstitutionType:PLDInstitutionTypeAmericanExpress];
    account.username = PLDTestMFAUsername;
    account.password = PLDTestPassword;
    
    [Plaid authenticateAccount:account completion:^(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error) {
        expect(authenticationItem).to.beNil;
        expect(error).to.beNil;
        if (!self.fullfilled) {
            [expectation fulfill];
            self.fullfilled = YES;
        } else {
        }
    }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testToVerifyConnectWithMFA
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Connect w/ Verification"];
    
    PLDAccount *account = [PLDAccount accountWithInstitutionType:PLDInstitutionTypeBankOfAmerica];
    account.username = PLDTestMFAUsername;
    account.password = PLDTestPassword;
    
    [Plaid connectAccount:account completion:^(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error) {
        authenticationItem.answer = @"Tomato";
        [Plaid completeAuthenticationWithItem:authenticationItem completion:^(BOOL success, NSError *error) {
            if (error.code == 1108) {
                if (!self.fullfilled) {
                    [expectation fulfill];
                    self.fullfilled = YES;
                } else {
                }
            }
        }];
    }];
    [self waitForCompletionWithTimeOut:30];
}

- (void)testToVerifyConnectWithoutMFA
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Connect Verification"];
    
    PLDAccount *account = [PLDAccount accountWithInstitutionType:PLDInstitutionTypeAmericanExpress];
    account.username = PLDTestMFAUsername;
    account.password = PLDTestPassword;
    
    [Plaid connectAccount:account completion:^(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error) {
        expect(authenticationItem).to.beNil;
        expect(error).to.beNil;
        if (!self.fullfilled) {
            [expectation fulfill];
            self.fullfilled = YES;
        } else {
        }
    }];
    [self waitForCompletionWithTimeOut:10];
}

- (void)testToVerifyTransactionDataPersisted
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Transaction Persistence Verification"];
    
    PLDAccount *account = [PLDAccount accountWithInstitutionType:PLDInstitutionTypeAmericanExpress];
    account.username = PLDTestMFAUsername;
    account.password = PLDTestPassword;
    
    [Plaid connectAccount:account completion:^(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error) {
        expect(authenticationItem).to.beNil;
        expect(error).to.beNil;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:PLDDidPersistedTransactionsNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                              NSArray *accounts = [Plaid allAccounts];
                                                              expect(accounts).toNot.beNil;
                                                              NSArray *transactions = [Plaid transactionForAccount:accounts[0]];
                                                              expect(transactions).toNot.beNil;
                                                              if (!self.fullfilled) {
                                                                  [expectation fulfill];
                                                                  self.fullfilled = YES;
                                                              } else {
                                                              }
                                                          });
                                                  }];
    
    [self waitForCompletionWithTimeOut:5];
    
}

- (void)testToVerifyAccountDataPersisted
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Account Persistence Verification"];
    
    PLDAccount *account = [PLDAccount accountWithInstitutionType:PLDInstitutionTypeAmericanExpress];
    account.username = PLDTestMFAUsername;
    account.password = PLDTestPassword;
    
    [Plaid connectAccount:account completion:^(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error) {
        expect(authenticationItem).to.beNil;
        expect(error).to.beNil;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:PLDDidPersistedTransactionsNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                          NSArray *accounts = [Plaid allAccounts];
                                                          expect(accounts).toNot.beNil;
                                                          if (!self.fullfilled) {
                                                              [expectation fulfill];
                                                              self.fullfilled = YES;
                                                          } else {
                                                          }
                                                      });
                                                  }];
    
    [self waitForCompletionWithTimeOut:5];
}

- (void)waitForCompletionWithTimeOut:(NSUInteger)timeout
{
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end
