//
//  Transaction+PLDTransaction.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/2/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Transaction+PLDTransaction.h"
#import "PLDUtilities.h"

NSString *const PLDTransactiontransactionKey = @"_transaction";
NSString *const PLDTransactionIdentifierKey = @"_id";
NSString *const PLDTransactionAmountKey = @"amount";
NSString *const PLDTransactionCategoryIDKey = @"category_id";
NSString *const PLDTransactionDateKey = @"date";
NSString *const PLDTransactionLocationKey = @"meta.location";
NSString *const PLDTransactionNameKey = @"name";
NSString *const PLDTransactionPendingKey = @"pending";

/*
{
    "_transaction" = YzzrzBrO9OSzo6BXwAvVuL5dmMKMqkhOoEqeo;
    "_id" = QllVljV252iNZej9VQgBCYkEyD4Do9fvZMAvmK;
    amount = "2307.15";
    category =             (
                            Shops,
                            "Computers and Electronics"
                            );
    "category_id" = 19013000;
    date = "2014-06-23";
    meta =             {
        location =                 {
            address = "1 Stockton St";
            city = "San Francisco";
            state = CA;
        };
    };
    name = "Apple Store";
    pending = 0;
    score =             {
        detail =                 {
            address = 1;
            city = 1;
            name = 1;
            state = 1;
        };
        master = 1;
    };
    type =             {
        primary = place;
    };
},
 */

@implementation Transaction (PLDTransaction)

static NSString *TransactionEntityName = @"Transaction";

+ (instancetype)initWithTransactionData:(NSDictionary *)transactionData withContect:(NSManagedObjectContext *)context
{
    Transaction *transaction = [NSEntityDescription insertNewObjectForEntityForName:TransactionEntityName inManagedObjectContext:context];
    if(transaction) {
        transaction.identifier = transactionData[PLDTransactionsKey];
        transaction.amount = transactionData[PLDTransactionAmountKey];
        transaction.categoryIdentifier = transactionData[PLDTransactionCategoryIDKey];
        transaction.date = transactionData[PLDTransactionDateKey];
        transaction.name = transactionData[PLDTransactionNameKey];
        transaction.pending = transactionData[PLDTransactionPendingKey];
    }
    return transaction;
}

+ (Transaction *)instanceWithIdentifier:(NSString *)identifier
                   managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
{
    if (![self checkForExistingEntity:TransactionEntityName withIdentifier:identifier andContext:managedObjectContext]) {
        return [NSEntityDescription insertNewObjectForEntityForName:TransactionEntityName inManagedObjectContext:managedObjectContext];
    }
    return nil;
}

@end
