//
// Created by Ilya Dyakonov on 10/03/14.
// Copyright (c) 2014 ZappyLab. All rights reserved.
//
//

#import <AFNetworking/AFNetworking.h>

#import "ZLNetworkRequestsPerformer.h"

/////////////////////////////////////////////////////

static NSString *const ZLNUserIdentifierKey = @"uid";
static NSString *const ZLNAppKey = @"app";
static NSString *const ZLNDeviceOSKey = @"dti";
static NSString *const ZLNOSiOS = @"1";

static NSString *const ZLNResponseStatusKey = @"request";
static NSString *const ZLNResponseStatusOK = @"OK";

/////////////////////////////////////////////////////

@interface ZLNetworkRequestsPerformer ()

@property (strong) AFHTTPRequestOperationManager *requestOperationManager;
@property (strong) NSString *appIdentifier;

@end

/////////////////////////////////////////////////////

@implementation ZLNetworkRequestsPerformer

#pragma mark - Class methods

static NSString *userIdentifier;

+(void)setUserIdentifier:(NSString *) identifier
{
    userIdentifier = identifier;
}

#pragma mark - Initialization

-(instancetype) init
{
    @throw [NSException exceptionWithName:@"NoInitMethod"
                                   reason:@"User initWithBaseURL:appIdentifier: for initialization purposes"
                                 userInfo:nil];
}

-(instancetype) initWithBaseURL:(NSURL *) baseURL
                  appIdentifier:(NSString *) appIdentifier
{
    NSParameterAssert(baseURL);
    NSParameterAssert(appIdentifier);

    self = [super init];
    if (self) {
        [self setupWithBaseURL:baseURL];
        _appIdentifier = appIdentifier;
    }

    return self;
}

-(void) setupWithBaseURL:(NSURL *) baseURL
{
    self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
}

#pragma mark - Requests

-(NSOperation *) POST:(NSString *) path
           parameters:(NSDictionary *) parameters
    completionHandler:(void (^)(BOOL success, NSDictionary *response, NSError *error)) completionHandler
{
    NSAssert(userIdentifier, @"unable to perform requests without user identifier");

    return [self.requestOperationManager POST:path
                                   parameters:[self completeParameters:parameters]
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
                                      {
                                          if ([self isResponseOK:responseObject])
                                          {
                                              if (completionHandler)
                                              {
                                                  completionHandler(YES, responseObject, nil);
                                              }
                                          }
                                          else
                                          {
                                              if (completionHandler)
                                              {
                                                  completionHandler(NO, responseObject, nil);
                                              }
                                          }
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                      {
                                          if (completionHandler)
                                          {
                                              completionHandler(NO, nil, error);
                                          }
                                      }];
}

-(NSDictionary *) completeParameters:(NSDictionary *) parameters
{
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[ZLNUserIdentifierKey] = userIdentifier;
    mutableParameters[ZLNAppKey] = self.appIdentifier;
    mutableParameters[ZLNDeviceOSKey] = ZLNOSiOS;
    return mutableParameters;
}

#pragma mark - Response validation

-(BOOL) isResponseOK:(NSDictionary *) response
{
    BOOL responseOK = NO;

    NSString *responseStatus = response[ZLNResponseStatusKey];
    if ([responseStatus isEqualToString:ZLNResponseStatusOK])
    {
        responseOK = YES;
    }

    return responseOK;
}

@end

/////////////////////////////////////////////////////
