//
// Created by Ilya Dyakonov on 10/03/14.
// Copyright (c) 2014 ZappyLab. All rights reserved.
//
//


#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////

extern NSString *const ZLNResponseErrorDomain;

/////////////////////////////////////////////////////

@interface ZLNetworkRequestsPerformer : NSObject

+(void) setUserIdentifier:(NSString *) identifier;

-(instancetype) initWithBaseURL:(NSURL *) baseURL
                  appIdentifier:(NSString *) appIdentifier;

-(NSOperation *) POST:(NSString *) path
                    parameters:(NSDictionary *) parameters
completionHandlerWithOperation:(void (^)(NSOperation *requestOperation, BOOL success, NSDictionary *response, NSError *error)) completionHandler;

-(NSOperation *) POST:(NSString *) path
           parameters:(NSDictionary *) parameters
    completionHandler:(void (^)(BOOL success, NSDictionary *response, NSError *error)) completionHandler;

@end

/////////////////////////////////////////////////////