//
//  Product.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/4/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Institution;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSNumber * auth;
@property (nonatomic, retain) NSNumber * balance;
@property (nonatomic, retain) NSNumber * connect;
@property (nonatomic, retain) Institution *institution;

@end
