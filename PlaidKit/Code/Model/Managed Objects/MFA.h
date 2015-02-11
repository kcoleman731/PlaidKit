//
//  MFA.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/4/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MFA : NSManagedObject

@property (nonatomic, retain) NSNumber * code;
@property (nonatomic, retain) NSNumber * list;
@property (nonatomic, retain) NSNumber * questions;

@end
