//
//  ApiDataProvider.h
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 01/11/2018.
//  Copyright © 2018 NxApple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#include "RequestWrapper.h"

extern NSString* const NsUSERSNOTIFICATION;
extern NSString* const NsALBUMSSNOTIFICATION;
extern NSString* const NsPOSTSNOTIFICATION;

typedef void(^errorCallback)(NSError* error);

@protocol FetchProtocol
-(void)fetchUsers:(errorCallback)callback;
-(void)fetchAlbums:(errorCallback)callback;
-(void)fetchPosts:(errorCallback)callback;
@end

@interface ApiDataProvider : NSObject <FetchProtocol> 
@property(nonatomic, strong, readonly) NSPersistentContainer *ppersistentContainer;
@property(nonatomic, strong, readonly) NSManagedObjectContext *pviewObjectContext;
-(instancetype)initWith :(NSPersistentContainer *)persistentContainer dataModel:(RequestWrapper*)requestWrapper;
@end

