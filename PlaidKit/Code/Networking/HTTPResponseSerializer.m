//
//  LSHTTPResponseSerializer.m
//  LayerSample
//
//  Created by Blake Watters on 6/28/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "HTTPResponseSerializer.h"

/* 
 Stats Code Details
 200: Success
 201: MFA Required
 400: Bad Request
 401: Unauthorized
 402: Request Failed
 404: Cannot be Found
 50X: Server Error
 
 Error Code Details
 100X: Bad Request
 110X: Unauthorized
 120X: User Authentication Invalid
 130X: Institutions Error
 140X: Entities Error
 150X: Categories Error
 160X: Item Missing
 170X: Server Error
 180X: Planned Maintenance
 
 */

NSString *const HTTPResponseErrorDomain = @"com.mercambia.PlaidKit.HTTPResponseError";
static NSRange const HTTPSuccessStatusCodeRange = {200, 100};
static NSRange const HTTPClientErrorStatusCodeRange = {400, 100};
static NSRange const HTTPServerErrorStatusCodeRange = {500, 100};

static NSRange const HTTPBadRequestStatusCodeRange = {1000, 100};
static NSRange const HTTPUnauthorizedStatusCodeRange = {1100, 100};
static NSRange const HTTPInvalidAuthStatusCodeRange = {1200, 100};
static NSRange const HTTPInstitutionsStatusCodeRange = {1300, 100};
static NSRange const HTTEntitiesStatusCodeRange = {1400, 100};
static NSRange const HTTPCategoriesStatusCodeRange = {1500, 100};
static NSRange const HTTPItemMissingStatusCodeRange = {1600, 100};
static NSRange const HTTPServerErrorCodeRange = {1700, 100};
static NSRange const HTTPMaintenanceCodeRange = {1800, 100};

typedef NS_ENUM(NSInteger, HTTPResponseStatus) {
    HTTPResponseStatusSuccess,
    HTTPResponseStatusClientError,
    HTTPResponseStatusServerError,
    HTTPResponseStatusOther,
};

static HTTPResponseStatus HTTPResponseStatusFromStatusCode(NSInteger statusCode)
{
    if (NSLocationInRange(statusCode, HTTPSuccessStatusCodeRange)) return HTTPResponseStatusSuccess;
    if (NSLocationInRange(statusCode, HTTPClientErrorStatusCodeRange)) return HTTPResponseStatusClientError;
    if (NSLocationInRange(statusCode, HTTPServerErrorStatusCodeRange)) return HTTPResponseStatusServerError;
    return HTTPResponseStatusOther;
}

static NSString *HTTPErrorMessageFromErrorRepresentation(id representation)
{
    if ([representation isKindOfClass:[NSString class]]) {
        return representation;
    } else if ([representation isKindOfClass:[NSArray class]]) {
        return [representation componentsJoinedByString:@", "];
    } else if ([representation isKindOfClass:[NSDictionary class]]) {
        // Check for direct error message
        id errorMessage = representation[@"error"];
        if (errorMessage) {
            return HTTPErrorMessageFromErrorRepresentation(errorMessage);
        }
        
        // Rails errors in nested dictionary
        id errors = representation[@"errors"];
        if ([errors isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *messages = [NSMutableArray new];
            [errors enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSString *description = HTTPErrorMessageFromErrorRepresentation(obj);
                NSString *message = [NSString stringWithFormat:@"%@ %@", key, description];
                [messages addObject:message];
            }];
            return [messages componentsJoinedByString:@" "];
        }
    }
    return [NSString stringWithFormat:@"An unknown error representation was encountered. (%@)", representation];
}

@implementation HTTPResponseSerializer

+ (BOOL)responseObject:(id *)object withData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError **)error
{
    NSParameterAssert(object);
    NSParameterAssert(response);
    
    if (data.length && ![response.MIMEType isEqualToString:@"application/json"]) {
        NSString *description = [NSString stringWithFormat:@"Expected content type of 'application/json', but encountered a response with '%@' instead.", response.MIMEType];
        if (error) *error = [NSError errorWithDomain:HTTPResponseErrorDomain code:HTTPResponseErrorInvalidContentType userInfo:@{NSLocalizedDescriptionKey: description}];
        return NO;
    }
  
    HTTPResponseStatus status = HTTPResponseStatusFromStatusCode(response.statusCode);
    if (status == HTTPResponseStatusServerError) {
        NSString *description = [NSString stringWithFormat:@"Error"];
        if (error) *error = [NSError errorWithDomain:HTTPResponseErrorDomain code:HTTPResponseErrorServerError userInfo:@{NSLocalizedDescriptionKey: description}];
        return NO;
    }

    // We have response body and passed Content-Type checks, deserialize it
    NSError *serializationError;
    id deserializedResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
    if (!deserializedResponse) {
        if (error) *error = serializationError;
        return NO;
    }
    
    if (status == HTTPResponseStatusClientError) {
        NSString *description = [deserializedResponse valueForKey:@"message"];
        NSString *recovery = [deserializedResponse valueForKey:@"resolve"];
        NSInteger code = [[deserializedResponse valueForKey:@"code"] integerValue];
        if (error) *error = [NSError errorWithDomain:HTTPResponseErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: description,
                                                                                                  NSLocalizedRecoverySuggestionErrorKey : recovery}];
        return NO;
    }
    
    
    if (status != HTTPResponseStatusSuccess) {
        NSString *errorMessage = HTTPErrorMessageFromErrorRepresentation(deserializedResponse);
        if (error) *error = [NSError errorWithDomain:HTTPResponseErrorDomain code:(status == HTTPResponseStatusClientError ? HTTPResponseErrorClientError : HTTPResponseErrorServerError) userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        return NO;
    }
    
    *object = deserializedResponse;
    return YES;
}

- (void)clientErrorWithResponse:(NSHTTPURLResponse *)response
{

}


@end
