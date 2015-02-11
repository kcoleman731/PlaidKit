//
//  PLDPersistTransactionsOperation.m
//  PlaidKit
//
//  Created by Kevin Coleman on 1/28/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDPersistTransactionsOperation.h"
#import "Transaction+PLDTransaction.h"

@interface PLDPersistTransactionsOperation ()

@property (nonatomic) NSDictionary *transactionData;

@end

@implementation PLDPersistTransactionsOperation

- (instancetype)initWithTransactionData:(NSDictionary *)transactionData
{
    self = [super init];
    if (self) {
        _transactionData = transactionData;
    }
    return self;
}

- (void)executeOperation
{
    for (NSDictionary *transactionData in self.transactionData) {
        [Transaction initWithTransactionData:transactionData withContect:self.context];
    }
    
    NSError *error;
    [self.context save:&error];
    if (error) {
        self.error = error;
    }
    [self finish];
}

@end
