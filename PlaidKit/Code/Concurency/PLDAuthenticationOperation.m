//
//  PLDAuthenticationOperation.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/2/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDAuthenticationOperation.h"
#import "PLDOperationController.h"

@interface PLDAuthenticationOperation ()

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) PLDInstitutionType institutionType;

@end

@implementation PLDAuthenticationOperation

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password institutionType:(PLDInstitutionType)institutionType
{
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
        _institutionType = institutionType;
    }
    return self;
}

- (void)executeOperation
{
    [[PLDServiceManager sharedService] connectWithUsername:self.username
                                          password:self.password
                                   institutionType:self.institutionType
                                           success:^(NSDictionary *responseData) {
                                               [self persistResponseData:responseData];
                                               [self finish];
                                            } failure:^(NSError *error) {
                                                NSLog(@"Test");
                                            }];
}

- (void)persistResponseData:(NSDictionary *)responseData
{
    NSString *accessToken = responseData[PLDAccesTokenKey];
    NSDictionary *accountData = responseData[PLDAccountsKey];
    NSDictionary *transactionData = responseData[PLDTransactionsKey];
    
    [self persistAccessToken:accessToken completion:^{
        [self persistAccountData:accountData completion:^{
            [self persistTransactionData:transactionData completion:^{
                [self finish];
            }];
        }];
    }];
}

- (void)persistAccessToken:(NSString *)accessToken completion:(void(^)(void))completion
{
    completion();
}

- (void)persistAccountData:(NSDictionary *)accountData completion:(void(^)(void))completion
{
//    [PLDOperationController persistAccountData:accountData completion:^{
//        completion();
//    }];
}

- (void)persistTransactionData:(NSDictionary *)transactionData completion:(void(^)(void))completion
{
//    [PLDOperationController persistTransactionData:transactionData completion:^{
//        completion();
//    }];
}





@end
