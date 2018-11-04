//
//  AlbumsAndPostsViewModel.m
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 19/06/2018.
//  Copyright © 2018 NxApple. All rights reserved.
//

#import "AlbumsAndPostsViewModel.h"
#import <UIKit/UITableView.h>
#include "CoreDataContainer.h"

@interface AlbumsAndPostsViewModel() {
    NSArray* albums;
    NSArray* posts;
}

@property NSFetchedResultsController* controllerAblum;
@property NSFetchedResultsController* controllerPost;
@end
@implementation AlbumsAndPostsViewModel

-(instancetype)init {
    
    self = [super init];
    if (!self) return nil;
    [self setContextParameters];
    [self setContextParameters1];
    return self;
}

-(NSUInteger)numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger nbRows = 0;
    if (section == 0)
        nbRows = albums.count;
    if (section == 1)
        nbRows = posts.count;
    
    return nbRows;
}

-(NSString*)titleOfCellAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellTitle = @"";
    if (indexPath.section == 0)
        cellTitle = albums[indexPath.row];
    if (indexPath.section == 1)
        cellTitle = posts[indexPath.row];
        
    return cellTitle;
}

-(NSString*)titleForSection:(NSInteger)section {
    
    NSString *sectionTitle;
    if (section == 0)
        sectionTitle = @"Albums";
    if (section == 1)
        sectionTitle = @"Posts";
    return sectionTitle;
}

-(void)albumsWithUserId:(NSUInteger)userId {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray* fetchOjects = [self.controllerAblum fetchedObjects];
    if (fetchOjects.count != 0) {
        for (NSManagedObject* obj in fetchOjects) {
            NSArray *keys = [[[obj entity] attributesByName] allKeys];
            NSDictionary *objectDict = [obj dictionaryWithValuesForKeys:keys];
            if ([objectDict[@"userId"] integerValue] == userId) {
                [array addObject:objectDict[@"title"]];
            }
        }
    }
    albums = array;
}

-(void)postsWithUserId:(NSUInteger)userId {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray* fetchOjects = [self.controllerPost fetchedObjects];
    if (fetchOjects.count != 0) {
        for (NSManagedObject* obj in fetchOjects) {
            NSArray *keys = [[[obj entity] attributesByName] allKeys];
            NSDictionary *objectDict = [obj dictionaryWithValuesForKeys:keys];
            if ([objectDict[@"userId"] integerValue] == userId) {
                [array addObject:objectDict[@"title"]];
            }
        }
    }
    posts = array;
}

-(void)setContextParameters {
    
    CoreDataContainer* coreDataContainer = [CoreDataContainer sharedCoreDataContainer];
    self.apiDataProvider = [[ApiDataProvider alloc] initWith: coreDataContainer.container dataModel: [RequestWrapper sharedRequestWrapper]];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Album"];
    NSSortDescriptor* sortDescriptors = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptors];
    self.controllerAblum = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.apiDataProvider.ppersistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
    self.controllerAblum.delegate = self;
    NSError *error;
    [self.controllerAblum performFetch:&error];
}

-(void)setContextParameters1 {
    
    CoreDataContainer* coreDataContainer = [CoreDataContainer sharedCoreDataContainer];
    self.apiDataProvider = [[ApiDataProvider alloc] initWith: coreDataContainer.container dataModel: [RequestWrapper sharedRequestWrapper]];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Post"];
    NSSortDescriptor* sortDescriptors = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptors];
    self.controllerPost = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.apiDataProvider.ppersistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
    self.controllerPost.delegate = self;
    NSError *error;
    [self.controllerPost performFetch:&error];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (controller == self.controllerAblum) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NsALBUMSSNOTIFICATION object:self];
    }
    if (controller == self.controllerPost){
        [[NSNotificationCenter defaultCenter] postNotificationName:NsPOSTSNOTIFICATION object:self];
    }
}


@end
