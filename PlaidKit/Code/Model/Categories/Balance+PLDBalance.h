//
//  Balance+PLDBalance.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/2/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Balance.h"
#import "NSManagedObject+PLDManagedObject.h"

extern NSString *const PLDBalanceIdentifier;
extern NSString *const PLDAvailableBalanceKey;
extern NSString *const PLDCurrentBalanceKey;

@interface Balance (PLDBalance)

+ (Balance *)initWithBalaceData:(NSDictionary *)balanceData withContect:(NSManagedObjectContext *)context;

@end
