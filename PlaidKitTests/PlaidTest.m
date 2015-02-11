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

@interface PlaidTest : XCTestCase

@end

@implementation PlaidTest

- (void)setUp
{
    [super setUp];
    [Plaid sharedInstanceWithClienID:PLDTestClientID secret:PLDTestSecret];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testToVerifyClientID
{

}

- (void)testToVerifyClientSecret
{
    
}

- (void)testToVerifyInstitutionsPersisted
{
    
}

- (void)testToVerifyCategoriesPersisted
{
    
}

- (void)testToVerifyAuthWithMFA
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Auth w/ MFA Verification"];
    
    PLDAccount *account = [PLDAccount accountWithInstitutionType:PLDInstitutionTypeBankOfAmerica];
    account.username = PLDTestMFAUsername;
    account.password = PLDTestPassword;
    
    [Plaid authenticateAccount:account completion:^(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error) {
        [expectation fulfill];
    }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testToVerifyAuthWithOutMFA
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Auth Verification"];
    
    PLDAccount *account = [PLDAccount accountWithInstitutionType:PLDInstitutionTypeBankOfAmerica];
    account.username = PLDTestUsername;
    account.password = PLDTestPassword;
    
    [Plaid authenticateAccount:account completion:^(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error) {
        authenticationItem.answer = @"Tomato";
        [Plaid completeAuthenticationWithItem:authenticationItem completion:^(BOOL success, NSError *error) {
            [expectation fulfill];
        }];
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
            //[expectation fulfill];
        }];
    }];
    [self waitForCompletionWithTimeOut:30];
}

- (void)testToVerifyConnectWithoutMFA
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Connect Verification"];
    
    PLDAccount *account = [PLDAccount accountWithInstitutionType:PLDInstitutionTypeBankOfAmerica];
    account.username = PLDTestMFAUsername;
    account.password = PLDTestPassword;
    
    [Plaid connectAccount:account completion:^(BOOL success, PLDAuthenticationItem *authenticationItem, NSError *error) {
        [expectation fulfill];
    }];
    [self waitForCompletionWithTimeOut:10];
}

- (void)testToVerifyTransactionDataPersisted
{

}

- (void)testToVerifyAccountDataPersisted
{
    
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
