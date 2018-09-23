//
//  RequestWrapper.m
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 14/06/2018.
//  Copyright © 2018 Ibrahima KH GUEYE. All rights reserved.
//

#import "RequestWrapper.h"

@implementation RequestWrapper

- (void)makeRequest:(NSURLRequest *)urlRequest callback:(CustomCallback)callback {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:callback];
    [dataTask resume];
}

@end
