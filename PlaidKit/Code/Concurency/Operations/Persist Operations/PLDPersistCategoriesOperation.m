//
//  PLDPersisteCategoriesOperation.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/4/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDPersistCategoriesOperation.h"
#import "P_Category+PLDCategory.h"

@interface PLDPersistCategoriesOperation ()

@property (nonatomic) NSDictionary *categoryData;

@end

@implementation PLDPersistCategoriesOperation

- (instancetype)initWithCategoryData:(NSDictionary *)categoryData
{
    self = [super init];
    if (self) {
        _categoryData = categoryData;
    }
    return self;
}

- (void)executeOperation
{
    if (self.isReady) {
        [self persistCategoryData];
    }
}

- (void)persistCategoryData
{
    for (NSDictionary *categoryData in self.categoryData) {
        [P_Category categoryWithData:categoryData context:self.context];
    }
    
    NSError *error;
    [self.context save:&error];
    if (error) {
        self.error = error;
    }
    [self finish];
}


@end
