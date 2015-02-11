//
//  PLDFetchAccountsOperation.m
//  PlaidKit
//
//  Created by Kevin Coleman on 1/28/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDFetchAccountsOperation.h"

@implementation PLDFetchAccountsOperation

- (void)executeOperation
{
    [self fetchTransationcs];
}

- (void)fetchTransationcs
{
    [[PLDServiceManager sharedService] accountInformationForAccessToken:nil success:^(NSDictionary *responseData) {
        //
    } failure:^(NSError *error) {
        //
    }];
}
@end
