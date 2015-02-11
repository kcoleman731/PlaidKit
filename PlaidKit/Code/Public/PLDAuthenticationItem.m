//
//  PLDAuthentication.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/5/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDAuthenticationItem.h"

@interface PLDAuthenticationItem ()

@end

@implementation PLDAuthenticationItem

NSString *const PLDAuthenticationItemAccessTokenKey = @"access_token";
NSString *const PLDAuthenticationItemMFAKey = @"mfa";
NSString *const PLDAuthenticationItemTypeKey = @"type";
NSString *const PLDAuthenticationItemQuestionKey = @"questions";
NSString *const PLDAuthenticationItemCodeKey = @"code";

+ (instancetype)itemWithResponseData:(NSDictionary *)responseData
{
    return [[self alloc] initWithResponseData:responseData];
}

- (id)initWithResponseData:(NSDictionary *)responseData
{
    self = [super init];
    if (self) {
        _accessToken = responseData[PLDAuthenticationItemAccessTokenKey];
        _type = [self authenticationTypeForString:responseData[PLDAuthenticationItemTypeKey]];
        _questions = responseData[PLDAuthenticationItemMFAKey];
    }
    return self;
}

- (PLDAuthenticationType)authenticationTypeForString:(NSString *)typeString
{
    if ([typeString isEqualToString:PLDAuthenticationItemQuestionKey]) {
        return PLDAuthenticationTypeQuestion;
    }
    if ([typeString isEqualToString:PLDAuthenticationItemCodeKey]) {
        return PLDAuthenticationTypeCode;
    }
    return NSNotFound;
}

@end
