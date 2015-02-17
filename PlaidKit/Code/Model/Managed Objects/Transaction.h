//
//  Transaction.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/16/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Location;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * categoryIdentifier;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pending;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) Location *location;

@end
