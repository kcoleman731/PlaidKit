//
//  PLDUser.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/8/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDAccount.h"

@implementation PLDAccount

+ (instancetype)accountWithInstitution:(Institution *)institution
{
    return [[self alloc] initWithInstitution:institution];
}

- (id)initWithInstitution:(Institution *)institution
{
    self = [super init];
    if (self) {
        _institution= institution;
    }
    return self;
}

- (NSString *)institutionType
{
    return self.institution.type;
}

@end
