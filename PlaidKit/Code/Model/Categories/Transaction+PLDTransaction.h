//
//  Transaction+PLDTransaction.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/2/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Transaction.h"
#import "NSManagedObject+PLDManagedObject.h"

extern NSString *const PLDTransactionEntityName;

extern NSString *const PLDTransactionIdentifierKey;
extern NSString *const PLDTransactionAmountKey;
extern NSString *const PLDTransactionCategoryIDKey;
extern NSString *const PLDTransactionDateKey;
extern NSString *const PLDTransactionNameKey;
extern NSString *const PLDTransactionPendingKey;

@interface Transaction (PLDTransaction)

+ (instancetype)initWithData:(NSDictionary *)data withContect:(NSManagedObjectContext *)context;

@end
