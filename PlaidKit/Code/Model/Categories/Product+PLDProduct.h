//
//  Product+PLDProduct.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/4/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Product.h"
#import "NSManagedObject+PLDManagedObject.h"

@interface Product (PLDProduct)

+ (Product *)productWithData:(NSArray *)data context:(NSManagedObjectContext *)context;

@end
