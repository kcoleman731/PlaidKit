//
//  PLDTransactionsOperation.h
//  PlaidKit
//
//  Created by Kevin Coleman on 1/28/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLDOperation.h"

@interface PLDFetchTransactionsOperation : PLDOperation

@property (nonatomic) NSDictionary *transactionData;

- (id)initWithAccessToken:(NSString *)accessToken;

@end
