//
//  PLDPersistTransactionsOperation.h
//  PlaidKit
//
//  Created by Kevin Coleman on 1/28/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDOperation.h"

@interface PLDPersistTransactionsOperation : PLDOperation

- (instancetype)initWithTransactionData:(NSDictionary *)transactionData;

@end
