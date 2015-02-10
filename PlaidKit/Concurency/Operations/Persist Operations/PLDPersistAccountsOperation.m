//
//  PLDAccountsOperation.m
//  PlaidKit
//
//  Created by Kevin Coleman on 1/28/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDPersistAccountsOperation.h"

@interface PLDPersistAccountsOperation ()

@property (nonatomic) NSDictionary *accountData;

@end

@implementation PLDPersistAccountsOperation

- (instancetype)initWithAccountData:(NSDictionary *)accountData
{
    self = [super init];
    if (self) {
        _accountData = accountData;
    }
    return self;
}

- (void)executeOperation
{
    for (NSDictionary *account in self.accountData) {
        
    }
    [self finish];
}

@end
