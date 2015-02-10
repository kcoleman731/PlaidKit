//
//  PLDAuthentication.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/5/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PLDAuthenticationType) {
    PLDAuthenticationTypeCode,
    PLDAuthenticationTypeQuestion
};

NSString *const PLDAuthenticationItemMFAKey;

@interface PLDAuthenticationItem : NSObject

+ (instancetype)itemWithResponseData:(NSDictionary *)responseData;

@property (nonatomic) NSString *answer;

@property (nonatomic) NSString *accessToken;

@property (nonatomic) PLDAuthenticationType type;

@property (nonatomic) NSDictionary *questions;

@property (nonatomic) NSString *explanation;

@end
