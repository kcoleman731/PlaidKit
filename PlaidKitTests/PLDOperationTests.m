//
//  PLDOperationTests.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/4/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PLDOperationController.h"

@interface PLDOperationTests : XCTestCase

@end

@implementation PLDOperationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchingInstitutions
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Plaid Connection Expectation"];
     
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
