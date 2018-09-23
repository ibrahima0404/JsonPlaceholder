//
//  DataModel.h
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 14/06/2018.
//  Copyright © 2018 Ibrahima KH GUEYE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestWrapper.h"

extern NSString* const NsUSERSNOTIFICATION;
extern NSString* const NsALBUMSSNOTIFICATION;
extern NSString* const NsPOSTSNOTIFICATION;
typedef void (^CustomCallback2)(id obj);
@protocol testProtocol
-(void)getTest:(CustomCallback2)callback;
@end

@protocol APIProtocol
-(void)getUsers;
-(void)getAlbums;
-(void)getPosts;
@end
@interface DataModel : NSObject<APIProtocol, testProtocol> {
    RequestWrapper *requestWrapper;
}
@property(nonatomic, readonly) NSArray* users;
@property(nonatomic, readonly) NSArray* albums;
@property(nonatomic, readonly) NSArray* posts;
+(DataModel*)sharedDataModel;
@end
