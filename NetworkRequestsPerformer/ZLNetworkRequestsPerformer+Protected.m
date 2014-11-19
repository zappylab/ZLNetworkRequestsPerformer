//
// Created by Ilya Dyakonov on 19/11/14.
//
//


#import "ZLNetworkRequestsPerformer+Protected.h"

/////////////////////////////////////////////////////

@implementation ZLNetworkRequestsPerformer (Protected)

-(NSError *) errorFromResponse:(NSDictionary *) response
{
    return [NSError errorWithDomain:ZLNResponseErrorDomain
                               code:0
                           userInfo:response];
}

@end

/////////////////////////////////////////////////////