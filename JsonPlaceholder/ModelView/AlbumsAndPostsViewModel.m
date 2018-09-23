//
//  AlbumsAndPostsViewModel.m
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 19/06/2018.
//  Copyright © 2018 NxApple. All rights reserved.
//

#import "AlbumsAndPostsViewModel.h"
#import <UIKit/UITableView.h>

@interface AlbumsAndPostsViewModel() {
    NSArray* albums;
    NSArray* posts;
}
@property(nonatomic, strong, readonly) DataModel *dataModel;
@end
@implementation AlbumsAndPostsViewModel
-(instancetype)init {
    self = [super init];
    if (!self) return nil;
    _dataModel = [DataModel sharedDataModel];
    [_dataModel getAlbums];
    [_dataModel getPosts];
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
    NSString *cellTitle;
    if (indexPath.section == 0) {
        cellTitle = albums[indexPath.row];
    }
    if (indexPath.section == 1) {
        cellTitle = posts[indexPath.row];
    }
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
    for (id obj in _dataModel.albums) {
        if ([obj[@"userId"] integerValue] == userId) {
            [array addObject:obj[@"title"]];
        }
    }
    albums = array;
}

-(void)postsWithUserId:(NSUInteger)userId {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id obj in _dataModel.posts) {
        if ([obj[@"userId"] integerValue] == userId) {
            [array addObject:obj[@"title"]];
        }
    }
    posts = array;
}


@end
