//
//  Institution.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/16/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Credential, Product;

@interface Institution : NSManagedObject

@property (nonatomic, retain) NSNumber * hasMFA;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Credential *credentials;
@property (nonatomic, retain) Product *products;

@end
