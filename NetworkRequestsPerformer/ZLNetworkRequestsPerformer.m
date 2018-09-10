//
// Created by Ilya Dyakonov on 10/03/14.
// Copyright (c) 2014 ZappyLab. All rights reserved.
//
//

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#import "ZLNetworkRequestsPerformer.h"
#import "ZLNetworkRequestsPerformer+Protected.h"

/////////////////////////////////////////////////////

static NSString *const ZLNUserIdentifierKey = @"uid";
static NSString *const ZLNAppKey = @"app";
static NSString *const ZLNDeviceOSKey = @"dti";
static NSString *const ZLNOSiOS = @"1";

static NSString *const ZLNResponseStatusOK = @"OK";

NSString *const ZLNResponseErrorDomain = @"ZLNetworkRequestsPerformer";

/////////////////////////////////////////////////////

@interface ZLNetworkRequestsPerformer ()

@property (strong) AFHTTPSessionManager *requestSessionManager;
@property (strong) NSString *appIdentifier;

@end

/////////////////////////////////////////////////////

@implementation ZLNetworkRequestsPerformer

#pragma mark - Class methods

static NSString *userIdentifier;

+(void) setUserIdentifier:(NSString *) identifier
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
    if (self)
    {
        [self setupWithBaseURL:baseURL];
        _appIdentifier = appIdentifier;
    }

    return self;
}

-(void) setupWithBaseURL:(NSURL *) baseURL
{
    self.requestSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/html"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    self.requestSessionManager.responseSerializer = jsonResponseSerializer;
    
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    policy.validatesDomainName = NO;
    policy.allowInvalidCertificates = YES;
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

#pragma mark - Requests

-(NSURLSessionDataTask *) POST:(NSString *) path
                    parameters:(NSDictionary *) parameters
             completionHandler:(void (^)(BOOL success, NSDictionary *response, NSError *error)) completionHandler
{
    NSAssert(userIdentifier, @"unable to perform requests without user identifier");
    return [self.requestSessionManager POST:path
                                 parameters:[self completeParameters:parameters]
                                   progress:nil
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
            {
                if (completionHandler)
                {
                    NSError *error = nil;
                    BOOL success = [self isResponseOK:responseObject];
                    if (!success)
                    {
                        error = [self errorFromResponse:responseObject];
                    }
                    
                    completionHandler(success, responseObject, error);
                }
            }
                                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
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

#pragma mark - Response handling

-(BOOL) isResponseOK:(NSDictionary *) response
{
    BOOL responseOK = NO;

    if ([[self responseMessage:response] isEqualToString:ZLNResponseStatusOK])
    {
        responseOK = YES;
    }

    return responseOK;
}

@end

/////////////////////////////////////////////////////
