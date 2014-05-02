//
// Created by Ilya Dyakonov on 15/12/13.
// Copyright (c) 2013 ZappyLab. All rights reserved.
//
//


#import <Foundation/Foundation.h>

#import "AFNetworking.h"

/////////////////////////////////////////////////////

static NSString *const kNetworkReachabilityStatusChangeNotification = @"NetworkReachabilityStatusChange";

/////////////////////////////////////////////////////

@interface ZLNetworkReachabilityObserver : NSObject

+(instancetype) sharedInstance;

@property (readonly) BOOL networkReachable;

@end

/////////////////////////////////////////////////////