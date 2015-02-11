//
//  PLDAccountsOperation.h
//  PlaidKit
//
//  Created by Kevin Coleman on 1/28/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLDOperation.h"

@interface PLDPersistAccountsOperation : PLDOperation

- (instancetype)initWithAccountData:(NSDictionary *)accountData;

@end
