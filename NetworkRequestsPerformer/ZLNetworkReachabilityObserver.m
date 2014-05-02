//
// Created by Ilya Dyakonov on 15/12/13.
// Copyright (c) 2013 ZappyLab. All rights reserved.
//
//


#import "ZLNetworkReachabilityObserver.h"

/////////////////////////////////////////////////////

#ifdef PRODUCTION
static NSString *const kReachabilityCheckAddress = @"https://www.pubchase.com";
#else
static NSString *const kReachabilityCheckAddress = @"http://dev.pubchase.com";
#endif

/////////////////////////////////////////////////////

@interface ZLNetworkReachabilityObserver ()

@property (readwrite) BOOL networkReachable;
@property (strong) AFHTTPRequestOperationManager *requestOperationManager;

@end

/////////////////////////////////////////////////////

@implementation ZLNetworkReachabilityObserver

#pragma mark - Instantiation

+(instancetype) sharedInstance
{
    static ZLNetworkReachabilityObserver *_sharedObserver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObserver = [[ZLNetworkReachabilityObserver alloc] init];
    });

    return _sharedObserver;
}

#pragma mark - Initialization

-(instancetype) init
{
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}

-(void) setup
{
    self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kReachabilityCheckAddress]];

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

        // notify all the other objects - ZLNetworkReachabilityObserver is the only one
        // class handling AFNetworking notifications
        [wSelf postReachabilityStatusChangeNotification];
    }];

    [self.requestOperationManager.reachabilityManager startMonitoring];
    self.networkReachable = self.requestOperationManager.reachabilityManager.isReachable;
}

-(void) postReachabilityStatusChangeNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkReachabilityStatusChangeNotification
                                                        object:self];
}

@end

/////////////////////////////////////////////////////