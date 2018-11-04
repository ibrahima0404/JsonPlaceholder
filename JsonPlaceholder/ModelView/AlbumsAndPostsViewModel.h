//
//  AlbumsAndPostsViewModel.h
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 19/06/2018.
//  Copyright © 2018 NxApple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiDataProvider.h"

@interface AlbumsAndPostsViewModel : NSObject<NSFetchedResultsControllerDelegate>
-(instancetype)init;
-(NSUInteger)numberOfRowsInSection:(NSInteger)section;
-(NSString*)titleOfCellAtIndexPath:(NSIndexPath*)indexPath;
-(NSString*)titleForSection:(NSInteger)section;
-(void)albumsWithUserId:(NSUInteger)userId;
-(void)postsWithUserId:(NSUInteger)userId;
@property(nonatomic, strong, readwrite) ApiDataProvider *apiDataProvider;
@end
