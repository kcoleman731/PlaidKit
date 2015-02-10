//
//  PLDUser.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/8/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDAccount.h"

@implementation PLDAccount

+ (instancetype)accountWithInstitutionType:(PLDInstitutionType )institutionType
{
    return [[self alloc] initWithInstitutionType:institutionType];
}

- (id)initWithInstitutionType:(PLDInstitutionType)institutionType
{
    self = [super init];
    if (self) {
        _institutionType = institutionType;
    }
    return self;
}
@end
