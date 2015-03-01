//
//  PLDUser.h
//  Pods
//
//  Created by Kevin Coleman on 3/1/15.
//
//

#import <Foundation/Foundation.h>

@protocol PLDUser <NSObject>

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *identifier;

@end
