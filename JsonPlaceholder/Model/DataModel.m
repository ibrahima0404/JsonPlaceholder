//
//  DataModel.m
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 14/06/2018.
//  Copyright © 2018 Ibrahima KH GUEYE. All rights reserved.
//

#import "DataModel.h"
NSString* const NsUSERSNOTIFICATION = @"USERSNOTIFICATION";
NSString* const NsALBUMSSNOTIFICATION = @"ALBUMSNOTIFICATION";
NSString* const NsPOSTSNOTIFICATION = @"POSTSNOTIFICATION";
@interface DataModel()

@end
@implementation DataModel
+(DataModel*)sharedDataModel {
    static DataModel *sharedDataModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataModel = [[self alloc] init];
    });
    return sharedDataModel;
}
-(instancetype)init {
    self = [super init];
    if (self) {
        requestWrapper = [[RequestWrapper alloc] init];
        return self;
    } else return nil;
}

-(void)getUsers {
    [requestWrapper makeRequest:USERS_URL callback:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        //_users
        if (error) {
            NSLog(@"Error from getUsers : %@",error.localizedDescription);
        } else {
            [self saveJsonData:taskData nameData:@"users.json"];
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:taskData options:0 error:&error];
            dispatch_async(dispatch_get_main_queue()  , ^{
                self->_users = jsonObjects;
                //self->_users = [self getNames:objects];
                [[NSNotificationCenter defaultCenter] postNotificationName:NsUSERSNOTIFICATION object:self];
            });
        }
    }];
}

-(NSArray*)getNames:(NSDictionary *)dict {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id obj in dict) {
        [array addObject:[obj valueForKey:@"name"]];
    }
    return array;
}

-(void)getAlbums {
    [requestWrapper makeRequest:ALBUMS_URL callback:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error from getAlbums : %@",error.localizedDescription);
        } else {
            [self saveJsonData:taskData nameData:@"albums.json"];
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:taskData options:0 error:&error];
            dispatch_async(dispatch_get_main_queue()  , ^{
                self->_albums = jsonObjects;
                [[NSNotificationCenter defaultCenter] postNotificationName:NsALBUMSSNOTIFICATION object:self];
            });
        }
    }];
}

-(void)getPosts {
    [requestWrapper makeRequest:POSTS_URL callback:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error from getPosts : %@",error.localizedDescription);
        } else {
            [self saveJsonData:taskData nameData:@"posts.json"];
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:taskData options:0 error:&error];
            dispatch_async(dispatch_get_main_queue()  , ^{
                self->_posts = jsonObjects;
                [[NSNotificationCenter defaultCenter] postNotificationName:NsPOSTSNOTIFICATION object:self];
            });
        }
    }];
}

- (void)getTest:(CustomCallback2)callback {
    [requestWrapper makeRequest:POSTS_URL callback:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        if (error) {
            callback(nil);
            NSLog(@"Error from getPosts : %@",error.localizedDescription);
        } else {
            
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:taskData options:0 error:&error];
            callback(jsonObjects);
//            dispatch_async(dispatch_get_main_queue()  , ^{
//                self->_posts = jsonObjects;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"PostsOK" object:self];
//            });
        }
    }];
}


-(NSURL *)getUrlToSaveData {
    NSURL *url = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    return url;
}

-(void)saveJsonData:(NSData *)jsonData nameData:(NSString *)nameData {
    NSURL *url = [[self getUrlToSaveData]URLByAppendingPathComponent:nameData];
    NSError *error;
    [jsonData writeToURL:url options:0 error:&error];
}

-(NSData *)getJsonData:(NSString *)nameData {
    NSURL *url = [[self getUrlToSaveData] URLByAppendingPathComponent:nameData];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:nil];
    return data;
}
@end
