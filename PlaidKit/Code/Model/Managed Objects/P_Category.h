//
//  P_Category.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/16/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface P_Category : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * type;

@end
