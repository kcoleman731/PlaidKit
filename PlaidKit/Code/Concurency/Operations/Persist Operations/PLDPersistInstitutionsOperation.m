//
//  PLDInstitutionsOperation.m
//  PlaidKit
//
//  Created by Kevin Coleman on 1/28/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDPersistInstitutionsOperation.h"
#import "Institution+PLDInstitution.h"
@interface PLDPersistInstitutionsOperation ()

@property (nonatomic) NSDictionary *institutionData;

@end
@implementation PLDPersistInstitutionsOperation

- (instancetype)initWithInstitutionData:(NSDictionary *)institutionData
{
    self = [super init];
    if (self) {
        _institutionData = institutionData;
    }
    return self;
}

- (void)executeOperation
{
    for (NSDictionary *institution in self.institutionData) {
        [Institution institutionWithData:institution context:self.context];
    }
    
    NSError *error;
    [self.context save:&error];
    if (error) {
        self.error = error;
    }
    [self finish];
}

@end
