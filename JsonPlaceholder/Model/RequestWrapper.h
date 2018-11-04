//
//  RequestWrapper.h
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 14/06/2018.
//  Copyright © 2018 Ibrahima KH GUEYE. All rights reserved.
//

#import <Foundation/Foundation.h>
#define USERS_URL [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://jsonplaceholder.typicode.com/users"]]
#define POSTS_URL [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://jsonplaceholder.typicode.com/posts"]]
#define ALBUMS_URL [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://jsonplaceholder.typicode.com/albums"]]

typedef void(^CustomCallback)(NSData *taskData, NSURLResponse *response, NSError *error);

@protocol HttpProtocol
-(void)makeRequest:(NSURLRequest*)urlRequest callback:(CustomCallback)callback;
@end

@interface RequestWrapper : NSObject<HttpProtocol>
+(RequestWrapper*)sharedRequestWrapper;
@end
