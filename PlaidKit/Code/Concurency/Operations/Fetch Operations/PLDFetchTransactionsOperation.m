//
//  PLDTransactionsOperation.m
//  PlaidKit
//
//  Created by Kevin Coleman on 1/28/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDFetchTransactionsOperation.h"
#import "PLDUtilities.h"

@interface PLDFetchTransactionsOperation ()

@property (nonatomic) NSString *accessToken;

@end

@implementation PLDFetchTransactionsOperation

- (id)initWithAccessToken:(NSString *)accessToken
{
    self = [super init];
    if (self) {
        _accessToken = accessToken;
    }
    return self;
}
- (void)executeOperation
{
    if (self.isReady) {
        [self fetchTransactions];
    }
}

- (void)fetchTransactions
{
    [self.serviceManager getTransactionsWithAccessToken:self.accessToken options:nil success:^(NSDictionary *responseData) {
        self.transactionData = responseData[PLDTransactionsKey];
        [self finish];
    } failure:^(NSError *error) {
        self.error = error;
        [self finish];
    }];
}

@end
