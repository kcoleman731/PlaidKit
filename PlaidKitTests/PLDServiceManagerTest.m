//
//  PlaidKitTests.m
//  PlaidKitTests
//
//  Created by Kevin Coleman on 1/25/15.
//  Copyright (c) 2015 Mercambia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PLDServiceManager.h"
#import "PLDServiceManager.h"
#import "PLDTestUtilities.h"

@interface PLDServiceManagerTest : XCTestCase

@property (nonatomic) PLDServiceManager *plaid;

@end

@implementation PLDServiceManagerTest

- (void)setUp
{
    [super setUp];
    
    NSURL *baseURL = [NSURL URLWithString:@"https://tartan.plaid.com/"];
    self.plaid = [PLDServiceManager initWithBaseURL:baseURL];
}

- (void)testConnectionEndpoint
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Connection Expectation"];
    [self.plaid connectWithUsername:PLDTestUsername password:PLDTestPassword institutionType:PLDInstitutionTypeAmericanExpress success:^(NSDictionary *responseData) {
        NSLog(@"Response Data: %@", responseData);
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testMFAAuthentication
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid MFA Auth Expectation"];
    [self.plaid connectWithUsername:PLDTestMFAUsername password:PLDTestPassword institutionType:PLDInstitutionTypeWellsFargo success:^(NSDictionary *responseData) {
        [self.plaid MFAAuthWithAnswer:@"tomato" accessToken:PLDTestAccessToken success:^(NSDictionary *responseData) {
            NSLog(@"Response Data: %@", responseData);
            [expectation fulfill];
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [self waitForCompletionWithTimeOut:10];
}

- (void)testUpdatingUser
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Update User Expectation"];
    [self.plaid updateWithUsername:PLDTestUsername password:PLDTestPassword accessToken:PLDTestAccessToken success:^(NSDictionary *responseData) {
        NSLog(@"Response Data: %@", responseData);
        [expectation fulfill];
    } failure:^(NSError *error) {
         NSLog(@"Error: %@", error);
    }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testDeletingUser
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Delete User Expectation"];
    [self.plaid deleteAccountForAccessToken:PLDTestAccessToken success:^(NSDictionary *responseData) {
        NSLog(@"Response Data: %@", responseData);
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testGettingAllTransactions
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Get Transactions Expectation"];
    [self.plaid getTransactionsWithAccessToken:PLDTestAccessToken options:nil success:^(NSDictionary *responseData) {
        NSLog(@"Response Data: %@", responseData);
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testAuthenticatingUser
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Connection Expectation"];
    [self.plaid authenticateWithUsername:PLDTestUsername password:PLDTestPassword institutionType:PLDInstitutionTypeWellsFargo success:^(NSDictionary *responseData) {
        NSLog(@"Response Data: %@", responseData);
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testGettingAccountInformation
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Connection Expectation"];
    [self.plaid accountInformationForAccessToken:PLDTestAccessToken success:^(NSDictionary *responseData) {
        NSLog(@"Response Data: %@", responseData);
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testDeletingAccount
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Account Deletion Expectation"];
    [self.plaid deleteAccountForAccessToken:PLDTestAccessToken success:^(NSDictionary *responseData) {
        NSLog(@"Response Data: %@", responseData);
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testGettingBalanceInformation
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Balance Info Expectation"];
    [self.plaid accountBalanceWithAccessToken:PLDTestAccessToken success:^(NSDictionary *responseData) {
        NSLog(@"Response Data: %@", responseData);
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [self waitForCompletionWithTimeOut:5];
}

- (void)testUpgradingUserToProduct
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Upgrade Customer Expectation"];
    [self.plaid upgrateAccountWithAccessToken:PLDTestAccessToken toProductType:PLDProductTypeAuth success:^(NSDictionary *responseData) {
        NSLog(@"Response Data: %@", responseData);
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
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

- (void)tearDown
{
    [super tearDown];
}

@end
