//
//  Transaction+PLDTransaction.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/2/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Transaction+PLDTransaction.h"
#import "PLDUtilities.h"
#import "Account+PLDAccount.h"

NSString *const PLDTransactiontransactionKey = @"_transaction";
NSString *const PLDTransactionAccountIdentifierKey = @"_account";
NSString *const PLDTransactionIdentifierKey = @"_id";
NSString *const PLDTransactionAmountKey = @"amount";
NSString *const PLDTransactionCategoryIdentifierKey = @"category_id";
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

NSString *const PLDTransactionEntityName = @"Transaction";

+ (instancetype)initWithData:(NSDictionary *)data withContect:(NSManagedObjectContext *)context
{
    Transaction *transaction = [self instanceWithIdentifier:data[PLDTransactionIdentifierKey] managedObjectContext:context];
    if(transaction) {
        transaction.account = [self accountForIdentifier:data[PLDTransactionAccountIdentifierKey] inContext:context];
        transaction.identifier = data[PLDTransactionIdentifierKey];
        transaction.amount = data[PLDTransactionAmountKey];
       // transaction.categoryIdentifier = data[PLDTransactionCategoryIdentifierKey];
        //transaction.date = data[PLDTransactionDateKey];
        transaction.name = data[PLDTransactionNameKey];
        transaction.pending = data[PLDTransactionPendingKey];
    }
    return transaction;
}

+ (Transaction *)instanceWithIdentifier:(NSString *)identifier
                   managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
{
    if (![self checkForExistingEntity:PLDTransactionEntityName withIdentifier:identifier andContext:managedObjectContext]) {
        return [NSEntityDescription insertNewObjectForEntityForName:PLDTransactionEntityName inManagedObjectContext:managedObjectContext];
    }
    return nil;
}

+ (Account *)accountForIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:PLDAccountEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"SELF.identifier = %@", identifier];
    NSError *error;
    NSArray *accounts = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Failed fetching insitutions with error %@", error);
    }
    return accounts.firstObject;
}

@end
