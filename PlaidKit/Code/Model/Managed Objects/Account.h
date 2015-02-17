//
//  Account.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/16/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Balance, Transaction, User;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * accessToken;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * institutionType;
@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSNumber * limit;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * routing;
@property (nonatomic, retain) NSString * shortNumber;
@property (nonatomic, retain) NSString * type;
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
