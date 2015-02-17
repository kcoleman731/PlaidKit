//
//  Balance.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/16/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface Balance : NSManagedObject

@property (nonatomic, retain) NSNumber * available;
@property (nonatomic, retain) NSNumber * current;
@property (nonatomic, retain) Account *account;

@end
