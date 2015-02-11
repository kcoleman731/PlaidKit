//
//  PLDFetchInstitutionsOperation.m
//  PlaidKit
//
//  Created by Kevin Coleman on 1/28/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDFetchInstitutionsOperation.h"
#import "PLDOperationController.h"

@implementation PLDFetchInstitutionsOperation

- (void)executeOperation
{
    [self fetchInstitutions];
}

- (void)fetchInstitutions
{
    [self.serviceManager institutionsWithSuccess:^(NSDictionary *responseData) {
        self.institutions = responseData;
        [self finish];
    } failure:^(NSError *error) {
        self.error = error;
        [self finish];
    }];
}

@end
