//
//  ApiDataProvider.m
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 01/11/2018.
//  Copyright © 2018 NxApple. All rights reserved.
//

#import "ApiDataProvider.h"

NSString* const NsUSERSNOTIFICATION = @"USERSNOTIFICATION";
NSString* const NsALBUMSSNOTIFICATION = @"ALBUMSNOTIFICATION";
NSString* const NsPOSTSNOTIFICATION = @"POSTSNOTIFICATION";

@interface ApiDataProvider()
    
@property(nonatomic, strong, readwrite) NSPersistentContainer *ppersistentContainer;
@property(nonatomic, strong, readwrite) RequestWrapper *prequestWrapper;
@property(nonatomic, strong, readwrite) NSManagedObjectContext *pviewObjectContext;

@end

@implementation ApiDataProvider

-(instancetype)initWith :(NSPersistentContainer *)persistentContainer dataModel:(RequestWrapper*)requestWrapper {
   
    if ([super init]) {
        self.ppersistentContainer = persistentContainer;
        self.prequestWrapper = requestWrapper;
        self.pviewObjectContext = self.ppersistentContainer.viewContext;
        return self;
    }
    return nil;
}

- (void)fetchAlbums:(nonnull errorCallback)callback {
    
    [self.prequestWrapper makeRequest:ALBUMS_URL callback:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        if (error) {
            callback(error);
            return;
        }
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:taskData options:0 error:&error];
        NSManagedObjectContext *manageContext = [self.ppersistentContainer newBackgroundContext];
        manageContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        manageContext.undoManager = nil;
        [self syncAlbumData:jsonObjects taskContext:manageContext];
        callback(nil);
    }];
}

- (void)fetchPosts:(nonnull errorCallback)callback {
    
    [self.prequestWrapper makeRequest:POSTS_URL callback:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        if (error) {
            callback(error);
            return;
        }
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:taskData options:0 error:&error];
        NSManagedObjectContext *manageContext = [self.ppersistentContainer newBackgroundContext];
        manageContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        manageContext.undoManager = nil;
        [self syncPostData:jsonObjects taskContext:manageContext];
        callback(nil);
    }];
}

- (void)fetchUsers:(nonnull errorCallback)callback {
    
    [self.prequestWrapper makeRequest:USERS_URL callback:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        if (error) {
            callback(error);
            return;
        }
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:taskData options:0 error:&error];
        NSManagedObjectContext *manageContext = [self.ppersistentContainer newBackgroundContext];
        manageContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        manageContext.undoManager = nil;
        [self syncUserData:jsonObjects taskContext:manageContext];
        callback(nil);
    }];
}

-(bool)syncUserData:(id)jsonObject taskContext:(NSManagedObjectContext*)taskContext {
    
    __block bool isSyncSuccess = false;
    [taskContext performBlockAndWait:^{
        NSFetchRequest* fetchUsers = [[NSFetchRequest alloc] init];
        [fetchUsers setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:taskContext]];
        [fetchUsers setReturnsObjectsAsFaults:NO];
        NSBatchDeleteRequest* batchDelRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchUsers];
        batchDelRequest.resultType = NSBatchDeleteResultTypeObjectIDs;
        NSError *error;
        NSBatchDeleteResult *resut = [taskContext.persistentStoreCoordinator executeRequest:batchDelRequest withContext:taskContext error:&error];
        if (error) {
            NSLog(@"Error batchDeleteResult = %@", error.localizedDescription);
        }
        
        NSManagedObjectID* objectsId = (NSManagedObjectID*)resut.result;
        NSDictionary* dictDelObjKey = @{NSDeletedObjectsKey : objectsId};
        [NSManagedObjectContext mergeChangesFromRemoteContextSave:dictDelObjKey intoContexts:@[self.ppersistentContainer.viewContext]];
        
        for (id user in jsonObject) {
           NSManagedObject*  nsManagementOb =  [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:taskContext];
            [nsManagementOb setValue:user[@"address"] forKey:@"address"];
            [nsManagementOb setValue:user[@"id"] forKey:@"id"];
            [nsManagementOb setValue:user[@"phone"] forKey:@"phone"];
            [nsManagementOb setValue:user[@"email"] forKey:@"email"];
            [nsManagementOb setValue:user[@"username"] forKey:@"username"];
            [nsManagementOb setValue:user[@"company"] forKey:@"company"];
            [nsManagementOb setValue:user[@"website"] forKey:@"website"];
            [nsManagementOb setValue:user[@"name"] forKey:@"name"];
        }
    
        if (taskContext.hasChanges) {
            [taskContext save: &error];
            if (error) {
                NSLog(@"Error save task contetxt = %@", error.localizedDescription);
            }
            [taskContext reset];
        }
        isSyncSuccess = true;
    }];

    return isSyncSuccess;
}

-(bool)syncPostData:(id)jsonObject taskContext:(NSManagedObjectContext*)taskContext {
    
    __block bool isSyncSuccess = false;
    [taskContext performBlockAndWait:^{
        NSFetchRequest* fetchPosts = [[NSFetchRequest alloc] init];
        [fetchPosts setEntity:[NSEntityDescription entityForName:@"Post" inManagedObjectContext:taskContext]];
        NSBatchDeleteRequest* batchDelRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchPosts];
        batchDelRequest.resultType = NSBatchDeleteResultTypeObjectIDs;
        NSError *error;
        NSBatchDeleteResult *resut = [taskContext.persistentStoreCoordinator executeRequest:batchDelRequest withContext:taskContext error:&error];
        if (error) {
            NSLog(@"Error batchDeleteResult = %@", error.localizedDescription);
        }
        
        NSManagedObjectID* objectsId = (NSManagedObjectID*)resut.result;
        NSDictionary* dictDelObjKey = @{NSDeletedObjectsKey : objectsId};
        [NSManagedObjectContext mergeChangesFromRemoteContextSave:dictDelObjKey intoContexts:@[self.ppersistentContainer.viewContext]];
        
        for (id post in jsonObject) {
            NSManagedObject*  nsManagementOb =  [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:taskContext];
            [nsManagementOb setValue:post[@"id"] forKey:@"id"];
            [nsManagementOb setValue:post[@"body"] forKey:@"body"];
            [nsManagementOb setValue:post[@"title"] forKey:@"title"];
            [nsManagementOb setValue:post[@"userId"] forKey:@"userId"];
        }
        
        if (taskContext.hasChanges) {
            [taskContext save: &error];
            if (error) {
                NSLog(@"Error save task contetxt = %@", error.localizedDescription);
            }
            [taskContext reset];
        }
        isSyncSuccess = true;
    }];
    
    return isSyncSuccess;
}

-(bool)syncAlbumData:(id)jsonObject taskContext:(NSManagedObjectContext*)taskContext {
    
    __block bool isSyncSuccess = false;
    [taskContext performBlockAndWait:^{
        NSFetchRequest* fetchAlbums = [[NSFetchRequest alloc] init];
        [fetchAlbums setEntity:[NSEntityDescription entityForName:@"Album" inManagedObjectContext:taskContext]];
        NSBatchDeleteRequest* batchDelRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchAlbums];
        batchDelRequest.resultType = NSBatchDeleteResultTypeObjectIDs;
        NSError *error;
        NSBatchDeleteResult *resut = [taskContext.persistentStoreCoordinator executeRequest:batchDelRequest withContext:taskContext error:&error];
        if (error) {
            NSLog(@"Error batchDeleteResult = %@", error.localizedDescription);
        }
        
        NSManagedObjectID* objectsId = (NSManagedObjectID*)resut.result;
        NSDictionary* dictDelObjKey = @{NSDeletedObjectsKey : objectsId};
        [NSManagedObjectContext mergeChangesFromRemoteContextSave:dictDelObjKey intoContexts:@[self.ppersistentContainer.viewContext]];
        
        for (id album in jsonObject) {
            NSManagedObject*  nsManagementOb =  [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:taskContext];
            [nsManagementOb setValue:album[@"id"] forKey:@"id"];
            [nsManagementOb setValue:album[@"title"] forKey:@"title"];
            [nsManagementOb setValue:album[@"userId"] forKey:@"userId"];
        }
        
        if (taskContext.hasChanges) {
            [taskContext save: &error];
            if (error) {
                NSLog(@"Error save task contetxt = %@", error.localizedDescription);
            }
            [taskContext reset];
        }
        isSyncSuccess = true;
    }];
    
    return isSyncSuccess;
}

@end
