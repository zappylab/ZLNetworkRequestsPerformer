//
// Created by Ilya Dyakonov on 19/11/14.
//
//


#import "ZLNetworkRequestsPerformer+Protected.h"

/////////////////////////////////////////////////////

static NSString *const ZLNResponseStatusKey = @"request";

/////////////////////////////////////////////////////

@implementation ZLNetworkRequestsPerformer (Protected)

-(NSString *) responseMessage:(NSDictionary *) response
{
    return response[ZLNResponseStatusKey];
}

-(NSError *) errorFromResponse:(NSDictionary *) response
{
    return [NSError errorWithDomain:ZLNResponseErrorDomain
                               code:0
                           userInfo:response];
}

@end

/////////////////////////////////////////////////////