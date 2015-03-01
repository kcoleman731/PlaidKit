//
//  PLDFetchCategoriesOperation.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/4/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDFetchCategoriesOperation.h"
#import "PLDOperationController.h"

@implementation PLDFetchCategoriesOperation

- (void)executeOperation
{
    if (self.isReady) {
        [self fetchCategories];
    }
}

- (void)fetchCategories
{
    [[PLDServiceManager sharedService] categoriesWithSuccess:^(NSDictionary *responseData) {
        self.categoryData = responseData;
        [self finish];
    } failure:^(NSError *error) {
        self.error = error;
        [self finish];
    }];
}

@end
