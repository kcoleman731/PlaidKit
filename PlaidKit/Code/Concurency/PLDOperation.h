//
//  PLDOperation.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/8/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PLDServiceManager.h"

@interface PLDOperation : NSOperation

@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic) NSThread *operationThread;

@property (nonatomic) PLDServiceManager *serviceManager;

@property (nonatomic) NSError *error;

- (void)executeOperation;

- (BOOL)saveContext;

- (void)finish;

- (void)cancel;


@end
