//
//  Product+PLDProduct.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/4/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Product+PLDProduct.h"

NSString *const PLDProductTypeConnect = @"connect";
NSString *const PLDProductTypeAuth = @"auth";
NSString *const PLDProductTypeBalance = @"balance";

@implementation Product (PLDProduct)

static NSString *const PLDProductEntityName = @"Product";

+ (Product *)productWithData:(NSArray *)data context:(NSManagedObjectContext *)context
{
    Product *product = [NSEntityDescription insertNewObjectForEntityForName:PLDProductEntityName inManagedObjectContext:context];
    if (product) {
        product.connect = [NSNumber numberWithBool:[data containsObject:PLDProductTypeConnect]];
        product.auth = [NSNumber numberWithBool:[data containsObject:PLDProductTypeAuth]];
        product.balance = [NSNumber numberWithBool:[data containsObject:PLDProductTypeBalance]];
    }
    return product;
}

@end
