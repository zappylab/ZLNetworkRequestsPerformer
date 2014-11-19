//
// Created by Ilya Dyakonov on 19/11/14.
//
//


#import <Foundation/Foundation.h>
#import "ZLNetworkRequestsPerformer.h"

/////////////////////////////////////////////////////

@interface ZLNetworkRequestsPerformer (Protected)

-(NSError *) errorFromResponse:(NSDictionary *) response;

@end

/////////////////////////////////////////////////////
