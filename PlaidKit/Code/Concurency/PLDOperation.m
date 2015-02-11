//
//  PLDOperation.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/8/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "PLDOperation.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define kLock               @"HSLock"
#define kHSIsloationQueue   @"HSCoreDataOperationQueue"
#define kHSWorkerThread     @"HSWorkerOperations"

typedef NS_ENUM(NSUInteger, PLDOperationState) {
    PLDOperationStatePaused         = -1,
    PLDOperationStateReady          = 1,
    PLDOperationStateExecuting      = 2,
    PLDOperationStateDone           = 3,
};

typedef signed short HSOperationState;

static inline NSString * PLDKeyPathFromOperationState(PLDOperationState state) {
    switch (state) {
        case PLDOperationStateReady:
            return @"isReady";
            
        case PLDOperationStateExecuting:
            return @"isExecuting";
            
        case PLDOperationStateDone:
            return @"isFinished";
            
        case PLDOperationStatePaused:
            return @"isPaused";
            
        default:
            return @"state";
    }
}

@interface PLDOperation ()

@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic) HSOperationState state;

@end

@implementation PLDOperation


#pragma mark - NS OPERATION INIT AND START

- (id)init
{
    self = [super init];
    if (self) {
        self.lock = [[NSRecursiveLock alloc] init];
        self.lock.name = kLock;
        self.state = PLDOperationStateReady;
    }
    return self;
}

- (void)start
{
    [self.lock lock];
    if ([self isReady]) {
        self.state = PLDOperationStateReady;
        [self executeOperation];
    }
    [self.lock unlock];
}

#pragma mark - ALAssetOperationLogic

- (void)executeOperation
{
    // Implemented By Subclass
}

#pragma mark - NS OPERATION STATES

- (void)setState:(HSOperationState)state
{
    if (self.isCancelled) return;
    
    [self.lock lock];
    
    NSString *newStateKey = PLDKeyPathFromOperationState(state);
    NSString *oldStateKey = PLDKeyPathFromOperationState(_state);
    
    [self willChangeValueForKey:newStateKey];
    [self willChangeValueForKey:oldStateKey];
    
    _state = state;
    
    [self didChangeValueForKey:oldStateKey];
    [self didChangeValueForKey:newStateKey];
    
    [self.lock unlock];
}

- (void)finish
{
    self.state = PLDOperationStateDone;
}

- (void)cancel
{
    [self.lock lock];
    if (![self isFinished] && ![self isCancelled]) {
        [self willChangeValueForKey:@"isCancelled"];
        
        [super cancel];
        [self didChangeValueForKey:@"isCancelled"];
    }
    [self.lock unlock];
}

#pragma mark - NSOperation KVO and Status Callbacks

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isReady
{
    return self.state == PLDOperationStateReady;
}

- (BOOL)isExecuting
{
    return self.state == PLDOperationStateExecuting;
}

- (BOOL)isFinished
{
    return self.state == PLDOperationStateDone;
}
#pragma mark - Private NSManagedObjectContext

- (BOOL)saveContext
{
    if (self.context.hasChanges) {
        NSError *saveError;
        BOOL success = [self.context save:&saveError];
        if (!success || saveError) {
            NSLog(@"Core Data Save Failed");
        }
        return success;
    }
    return NO;
}

- (void)setCompletionBlock:(void (^)(void))block
{
    void(^mainQueueBlock)(void) = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) block();
        });
    };
    [super setCompletionBlock:mainQueueBlock];
}

@end
