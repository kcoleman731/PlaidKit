//
//  PlaidKit.m
//  PlaidKit
//
//  Created by Kevin Coleman on 1/25/15.
//  Copyright (c) 2015 Mercambia. All rights reserved.
//

#import "PLDServiceManager.h"
#import "HTTPResponseSerializer.h"
#import "PLDUtilities.h"

@interface PLDServiceManager () <NSURLSessionDelegate>

@property (nonatomic) NSURL *baseURL;
@property (nonatomic) NSURLSession *URLSession;
@property (nonatomic) NSURLSessionConfiguration *authenticatedURLSessionConfiguration;

@end

@implementation PLDServiceManager

+ (id)sharedService
{
    static PLDServiceManager *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"https://tartan.plaid.com/"];
        sharedService = [self initWithBaseURL:baseURL];
    });
    return sharedService;
}

+ (instancetype)initWithBaseURL:(NSURL *)baseURL;
{
    NSParameterAssert(baseURL);
    return [[self alloc] initWithBaseURL:baseURL];
}

- (id)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        _baseURL = baseURL;
        _URLSession = [self defaultURLSession];
    }
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Failed to call designated initializer." userInfo:nil];
}

- (NSURLSession *)defaultURLSession
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"Accept": @"application/json",
                                            @"Content-Type": @"application/json"};
    return [NSURLSession sessionWithConfiguration:configuration];
}

#pragma mark - /connect methods

- (void)connectWithUsername:(NSString *)username
                   password:(NSString *)password
            institutionType:(PLDInstitutionType)institutionType
                    success:(void(^)(NSDictionary *responseData))success
                    failure:(void(^)(NSError *error))failure
{
    
    NSURL *URL = [NSURL URLWithString:@"connect" relativeToURL:self.baseURL];
    NSDictionary *parameters = [self bodyWithParameters:@{PLDInstitutionTypeKey: PLDInstitutionWithType(institutionType),
                                                          PLDUsernameKey : username,
                                                          PLDPasswordKey : password}];
    [self requestWithType:@"POST" URL:URL parameters:parameters completion:^(NSDictionary *responseData, NSError *error) {
        if (error) {
            [self dispatchError:error withFailure:failure];
        } else {
            [self dispatchResponseData:responseData withSuccess:success];
        }
    }];
}

- (void)MFAAuthWithAnswer:(NSString *)answer
              accessToken:(NSString *)accessToken
                  success:(void (^)(NSDictionary *))success
                  failure:(void (^)(NSError *))failure
{
    NSURL *URL = [NSURL URLWithString:@"connect/step" relativeToURL:self.baseURL];
    NSDictionary *parameters = [self bodyWithParameters:@{PLDMFAKey : answer,
                                                          PLDAccesTokenKey : accessToken}];
    [self requestWithType:@"POST" URL:URL parameters:parameters completion:^(NSDictionary *responseData, NSError *error) {
        if (error) {
            [self dispatchError:error withFailure:failure];
        } else {
            [self dispatchResponseData:responseData withSuccess:success];
        }
    }];
}

- (void)updateWithUsername:(NSString *)username
                  password:(NSString *)password
               accessToken:(NSString *)accessToken
                   success:(void(^)(NSDictionary *responseData))success
                   failure:(void(^)(NSError *error))failure
{
    NSURL *URL = [NSURL URLWithString:@"connect" relativeToURL:self.baseURL];
    NSDictionary *parameters = [self bodyWithParameters:@{PLDUsernameKey : username,
                                                          PLDPasswordKey : password,
                                                          PLDAccesTokenKey : accessToken}];
    [self requestWithType:@"PATCH" URL:URL parameters:parameters completion:^(NSDictionary *responseData, NSError *error) {
        if (error) {
            [self dispatchError:error withFailure:failure];
        } else {
            [self dispatchResponseData:responseData withSuccess:success];
        }
    }];
}

- (void)deleteAccountForAccessToken:(NSString *)accessToken
                            success:(void(^)(NSDictionary *responseData))success
                            failure:(void(^)(NSError *error))failure;
{
    NSURL *URL = [NSURL URLWithString:@"connect" relativeToURL:self.baseURL];
    NSDictionary *parameters = [self bodyWithParameters:@{PLDAccesTokenKey :    accessToken}];
    [self requestWithType:@"DELETE" URL:URL parameters:parameters completion:^(NSDictionary *responseData, NSError *error) {
        if (error) {
            [self dispatchError:error withFailure:failure];
        } else {
            [self dispatchResponseData:responseData withSuccess:success];
        }
    }];
}

- (void)getTransactionsWithAccessToken:(NSString *)accessToken
                               options:(NSDictionary *)options
                               success:(void(^)(NSDictionary *responseData))success
                               failure:(void(^)(NSError *error))failure
{
    NSURL *URL = [NSURL URLWithString:@"connect/get" relativeToURL:self.baseURL];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:@{PLDAccesTokenKey : accessToken}];
    if (options) [dictionary setValue:options forKey:PLDOptionsKey];
    NSDictionary *parameters = [self bodyWithParameters:dictionary];
    [self requestWithType:@"POST" URL:URL parameters:parameters completion:^(NSDictionary *responseData, NSError *error) {
        if (error) {
            [self dispatchError:error withFailure:failure];
        } else {
            [self dispatchResponseData:responseData withSuccess:success];
        }
    }];
}


#pragma mark - /auth methods

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                 institutionType:(PLDInstitutionType)institutionType
                         success:(void(^)(NSDictionary *responseData))success
                         failure:(void(^)(NSError *error))failure
{
    
    NSURL *URL = [NSURL URLWithString:@"auth" relativeToURL:self.baseURL];
    NSDictionary *parameters = [self bodyWithParameters:@{PLDInstitutionTypeKey: PLDInstitutionWithType(institutionType),
                                                          PLDUsernameKey : username,
                                                          PLDPasswordKey : password}];
    [self requestWithType:@"POST" URL:URL parameters:parameters completion:^(NSDictionary *responseData, NSError *error) {
        if (error) {
            [self dispatchError:error withFailure:failure];
        } else {
            [self dispatchResponseData:responseData withSuccess:success];
        }
    }];
}

- (void)accountInformationForAccessToken:(NSString *)accessToken
                                 success:(void(^)(NSDictionary *responseData))success
                                 failure:(void(^)(NSError *error))failure
{
    NSURL *URL = [NSURL URLWithString:@"auth/get" relativeToURL:self.baseURL];
    NSDictionary *parameters = [self bodyWithParameters:@{PLDAccesTokenKey : accessToken}];
    [self requestWithType:@"POST" URL:URL parameters:parameters completion:^(NSDictionary *responseData, NSError *error) {
        if (error) {
            [self dispatchError:error withFailure:failure];
        } else {
            [self dispatchResponseData:responseData withSuccess:success];
        }
    }];
}

//- (void)deleteAccountForAccessToken:(NSString *)accessToken
//                            success:(void(^)(NSDictionary *responseData))success
//                            failure:(void(^)(NSError *error))failure
//{
//    NSURL *URL = [NSURL URLWithString:@"auth" relativeToURL:self.baseURL];
//    NSDictionary *parameters = [self bodyWithParameters:@{PLDAccesTokenKey : self.accessToken}];
//    [self requestWithType:@"DELETE" URL:URL parameters:parameters completion:^(NSDictionary *responseData, NSError *error) {
//        if (error) {
//            [self dispatchError:error withFailure:failure];
//        } else {
//            [self dispatchResponseData:responseData withSuccess:success];
//        }
//    }];
//}


#pragma mark - /balance methods

- (void)accountBalanceWithAccessToken:(NSString *)accessToken
                              success:(void(^)(NSDictionary *responseData))success
                              failure:(void(^)(NSError *error))failure;
{
    NSURL *URL = [NSURL URLWithString:@"balance" relativeToURL:self.baseURL];
    NSDictionary *parameters = [self bodyWithParameters:@{PLDAccesTokenKey : accessToken}];
    [self requestWithType:@"POST" URL:URL parameters:parameters completion:^(NSDictionary *responseData, NSError *error) {
        if (error) {
            [self dispatchError:error withFailure:failure];
        } else {
            [self dispatchResponseData:responseData withSuccess:success];
        }
    }];
}

#pragma mark - /upgrade methods

- (void)upgrateAccountWithAccessToken:(NSString *)accessToken
                        toProductType:(PLDProductType)productType
                              success:(void(^)(NSDictionary *responseData))success
                              failure:(void(^)(NSError *error))failure;
{
    NSURL *URL = [NSURL URLWithString:@"connect/step" relativeToURL:self.baseURL];
    NSDictionary *parameters = [self bodyWithParameters:@{PLDUpgradeKey: @"nil",
                                                          PLDAccesTokenKey : accessToken,
                                                          PLDUpgradeKey : PLDProductWithType(productType)}];
    [self requestWithType:@"POST" URL:URL parameters:parameters completion:^(NSDictionary *responseData, NSError *error) {
        if (error) {
            [self dispatchError:error withFailure:failure];
        } else {
            [self dispatchResponseData:responseData withSuccess:success];
        }
    }];
}

- (void)institutionsWithSuccess:(void(^)(NSDictionary *responseData))success
                        failure:(void(^)(NSError *error))failure
{
    NSURL *URL = [NSURL URLWithString:@"institutions" relativeToURL:self.baseURL];
    [self requestWithType:@"GET" URL:URL parameters:nil completion:^(NSDictionary *responseData, NSError *error) {
        if (error) {
            [self dispatchError:error withFailure:failure];
        } else {
            [self dispatchResponseData:responseData withSuccess:success];
        }
    }];
}

- (void)categoriesWithSuccess:(void(^)(NSDictionary *responseData))success
                        failure:(void(^)(NSError *error))failure
{
    NSURL *URL = [NSURL URLWithString:@"categories" relativeToURL:self.baseURL];
    [self requestWithType:@"GET" URL:URL parameters:nil completion:^(NSDictionary *responseData, NSError *error) {
        if (error) {
            [self dispatchError:error withFailure:failure];
        } else {
            [self dispatchResponseData:responseData withSuccess:success];
        }
    }];
}
#pragma mark - Private Implementation Methods

- (void)requestWithType:(NSString *)type
                    URL:(NSURL *)URL
             parameters:(NSDictionary *)parameters
             completion:(void(^)(NSDictionary *respnseData, NSError *error))completion
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = type;
    if (parameters) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    }
    [[self.URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *responseData;
        if (error) {
            completion(nil, error);
            return;
        } else {
            NSError *serializationError;
            [HTTPResponseSerializer responseObject:&responseData
                                          withData:data
                                          response:(NSHTTPURLResponse *)response
                                             error:&serializationError];
            NSLog(@"Response Data %@", responseData);
            completion(responseData, serializationError);
        }
    }] resume];
}

- (NSDictionary *)bodyWithParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *params = [parameters mutableCopy];
    [params setValue:self.clientID forKey:PLDClientIDKey];
    [params setValue:self.secret forKey:PLDSecretKey];
    return params;
}

- (void)dispatchResponseData:(NSDictionary *)responseData
                 withSuccess:(void (^)(NSDictionary *responseData))success
{
    dispatch_async(dispatch_get_main_queue(), ^{
        success(responseData);
    });
}

- (void)dispatchError:(NSError *)error
          withFailure:(void(^)(NSError *error))failure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        failure(error);
    });
}

@end
