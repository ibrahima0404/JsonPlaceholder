//
//  UsersViewModel.m
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 17/06/2018.
//  Copyright © 2018 NxApple. All rights reserved.
//

#import "UsersViewModel.h"
#import <UIKit/UITableView.h>
#include "CoreDataContainer.h"

@interface UsersViewModel()
@property NSFetchedResultsController* controller;

@end

@implementation UsersViewModel

-(instancetype)init {
    
    self = [super init];
    if (!self) return nil;
    [self setContextParameters];
    return self;
}

-(NSUInteger)numberOfRowsInsection:(NSInteger)section {
    
    return self.controller.fetchedObjects.count;
}

-(NSString*)titleOfCellAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellTitle = @"";
    NSArray* fetchOjects = [self.controller fetchedObjects];
    if (fetchOjects.count != 0) {
        NSManagedObject* userObject = [fetchOjects objectAtIndex:indexPath.row];
        NSArray *keys = [[[userObject entity] attributesByName] allKeys];
        NSDictionary *userObjectDict = [userObject dictionaryWithValuesForKeys:keys];
        cellTitle =  userObjectDict[@"name"];
    }
    return cellTitle;
}

-(NSUInteger)userIdAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray* fetchOjects = [self.controller fetchedObjects];
    NSManagedObject* userObject = [fetchOjects objectAtIndex:indexPath.row];
    NSArray *keys = [[[userObject entity] attributesByName] allKeys];
    NSDictionary *userObjectDict = [userObject dictionaryWithValuesForKeys:keys];
    NSUInteger userId = [userObjectDict[@"id"] longValue];
    return userId;
}

-(void)setContextParameters {
    
    CoreDataContainer* coreDataContainer = [CoreDataContainer sharedCoreDataContainer];
    self.apiDataProvider = [[ApiDataProvider alloc] initWith: coreDataContainer.container dataModel: [RequestWrapper sharedRequestWrapper]];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSSortDescriptor *sortDescriptors = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptors];
    self.controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.apiDataProvider.ppersistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
    self.controller.delegate = self;
    NSError *error;
    [self.controller performFetch:&error];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NsUSERSNOTIFICATION object:self];
}

@end
