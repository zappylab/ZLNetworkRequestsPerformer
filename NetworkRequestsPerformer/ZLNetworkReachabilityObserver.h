//
// Created by Ilya Dyakonov on 15/12/13.
// Copyright (c) 2013 ZappyLab. All rights reserved.
//
//


#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////

static NSString *const ZLNNetworkReachabilityStatusChangeNotification = @"NetworkReachabilityStatusChange";

/////////////////////////////////////////////////////

@interface ZLNetworkReachabilityObserver : NSObject

-(instancetype) initWithURL:(NSURL *) URL;

@property (readonly) BOOL networkReachable;

@end

/////////////////////////////////////////////////////