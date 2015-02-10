//
//  Account.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/4/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Balance, Transaction, User;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * accessToken;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * institutionType;
@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSNumber * limit;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Balance *balance;
@property (nonatomic, retain) User *owner;
@property (nonatomic, retain) NSSet *transactions;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

@end
