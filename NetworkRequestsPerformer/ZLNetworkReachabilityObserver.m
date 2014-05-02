//
// Created by Ilya Dyakonov on 15/12/13.
// Copyright (c) 2013 ZappyLab. All rights reserved.
//
//


#import <AFNetworking/AFNetworking.h>

#import "ZLNetworkReachabilityObserver.h"

/////////////////////////////////////////////////////

@interface ZLNetworkReachabilityObserver ()

@property (readwrite) BOOL networkReachable;
@property (strong) AFHTTPRequestOperationManager *requestOperationManager;

@end

/////////////////////////////////////////////////////

@implementation ZLNetworkReachabilityObserver

#pragma mark - Initialization

-(instancetype) init
{
    @throw [NSException exceptionWithName:@""
                                   reason:@"User initWithURL: for initialization purposes"
                                 userInfo:nil];
}

-(instancetype) initWithURL:(NSURL *) URL
{
    self = [super init];
    if (self) {
        [self setupWithURL:URL];
    }

    return self;
}

-(void) setupWithURL:(NSURL *) URL
{
    self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:URL];
    [self startObservingReachability];
}

#pragma mark - Observing

-(void) startObservingReachability
{
    __weak ZLNetworkReachabilityObserver *wSelf = self;
    [self.requestOperationManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        if (status == AFNetworkReachabilityStatusNotReachable ||
                status == AFNetworkReachabilityStatusUnknown)
        {
            wSelf.networkReachable = NO;
        }
        else {
            wSelf.networkReachable = YES;
        }

        // notify all other objects - ZLNetworkReachabilityObserver is the only one
        // class handling AFNetworking notifications
        [wSelf postReachabilityStatusChangeNotification];
    }];

    [self.requestOperationManager.reachabilityManager startMonitoring];
    self.networkReachable = self.requestOperationManager.reachabilityManager.isReachable;
}

-(void) postReachabilityStatusChangeNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLNNetworkReachabilityStatusChangeNotification
                                                        object:self];
}

@end

/////////////////////////////////////////////////////