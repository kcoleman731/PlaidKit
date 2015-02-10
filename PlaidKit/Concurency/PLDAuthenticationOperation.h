//
//  PLDAuthenticationOperation.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/2/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDOperation.h"

@interface PLDAuthenticationOperation : PLDOperation

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password institutionType:(PLDInstitutionType)institutionType;

@end
