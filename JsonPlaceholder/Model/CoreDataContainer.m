//
//  CoreDataContainer.m
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 03/11/2018.
//  Copyright © 2018 NxApple. All rights reserved.
//

#import "CoreDataContainer.h"

@interface CoreDataContainer ()
@property(nonatomic, strong, readwrite) NSPersistentContainer *container;
@end

@implementation CoreDataContainer

+(CoreDataContainer*)sharedCoreDataContainer {
    
    static CoreDataContainer *sharedCoreDataContainer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCoreDataContainer = [[self alloc] init];
    });
    return sharedCoreDataContainer;
}

-(instancetype)init {
    
    self = [super init];
    if (self) {
        self.container = [self persistentContainer];
        return self;
    } else return nil;
}

- (NSPersistentContainer *)persistentContainer {
    
    NSPersistentContainer *container = [[NSPersistentContainer alloc] initWithName:@"DataStorage"];
    [container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * persistent, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        container.viewContext.undoManager = nil;
        container.viewContext.shouldDeleteInaccessibleFaults = YES;
        container.viewContext.automaticallyMergesChangesFromParent = YES;
    }];
    return container;
}

@end
