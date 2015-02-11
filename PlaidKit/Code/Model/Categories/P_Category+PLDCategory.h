//
//  P_Category+PLDCategory.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/5/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "P_Category.h"

extern NSString * PLDCategoryEntityName;

@interface P_Category (PLDCategory)

+ (P_Category *)categoryWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context;

@end
