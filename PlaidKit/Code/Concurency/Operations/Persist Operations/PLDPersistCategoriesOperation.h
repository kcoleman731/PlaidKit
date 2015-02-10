//
//  PLDPersisteCategoriesOperation.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/4/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLDOperation.h"

@interface PLDPersistCategoriesOperation : PLDOperation

- (instancetype)initWithCategoryData:(NSDictionary *)categoryData;

@end
