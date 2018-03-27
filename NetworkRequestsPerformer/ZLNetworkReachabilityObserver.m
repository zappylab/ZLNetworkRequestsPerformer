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
@property (strong) AFHTTPSessionManager *requestSessionManager;

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
    self.requestSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    policy.validatesDomainName = NO;
    policy.allowInvalidCertificates = YES;
    self.requestSessionManager.securityPolicy = policy;
    [self startObservingReachability];
}

#pragma mark - Observing

-(void) startObservingReachability
{
    __weak ZLNetworkReachabilityObserver *wSelf = self;
    [self.requestSessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
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

    [self.requestSessionManager.reachabilityManager startMonitoring];
    self.networkReachable = self.requestSessionManager.reachabilityManager.isReachable;
}

-(void) postReachabilityStatusChangeNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLNNetworkReachabilityStatusChangeNotification
                                                        object:self];
}

@end

/////////////////////////////////////////////////////
