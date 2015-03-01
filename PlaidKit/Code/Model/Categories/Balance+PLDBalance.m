//
//  Balance+PLDBalance.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/2/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Balance+PLDBalance.h"
#import "PLDUtilities.h"

@implementation Balance (PLDBalance)

NSString *const PLDBalanceIdentifier = @"Balance";
NSString *const PLDAvailableBalanceKey = @"AvailableBalanceKey";
NSString *const PLDCurrentBalanceKey = @"CurrentBalanceKey";

/*
 balance = {
     available = "1203.42";
     current = "1274.93";
 }
 */

+ (Balance *)initWithBalaceData:(NSDictionary *)balanceData withContect:(NSManagedObjectContext *)context
{
    Balance *balance = [NSEntityDescription insertNewObjectForEntityForName:PLDBalanceIdentifier inManagedObjectContext:context];
    if (balance) {
        balance.current = balanceData[PLDCurrentBalanceKey];
        balance.available = balanceData[PLDAvailableBalanceKey];
    }
    return balance;
}

@end
