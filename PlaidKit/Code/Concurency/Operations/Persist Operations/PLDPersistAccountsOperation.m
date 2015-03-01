//
//  PLDAccountsOperation.m
//  PlaidKit
//
//  Created by Kevin Coleman on 1/28/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDPersistAccountsOperation.h"
#import "Account+PLDAccount.h"

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
    for (NSDictionary *accountData in self.accountData) {
        [Account initWithAccountData:accountData context:self.context];
    }
    NSError *error;
    [self.context save:&error];
    if (error) {
        self.error = error;
    }
    [self finish];
}

@end
