//
//  PLDUser.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/8/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Institution+PLDInstitution.h"

@interface PLDAccount : NSObject

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *institutionType;
@property (nonatomic) Institution *institution;

+ (instancetype)accountWithInstitution:(Institution *)institution;


@end
