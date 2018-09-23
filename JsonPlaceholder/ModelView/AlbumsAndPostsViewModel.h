//
//  AlbumsAndPostsViewModel.h
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 19/06/2018.
//  Copyright © 2018 NxApple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"
@interface AlbumsAndPostsViewModel : NSObject
-(instancetype)init;
-(NSUInteger)numberOfRowsInSection:(NSInteger)section;
-(NSString*)titleOfCellAtIndexPath:(NSIndexPath*)indexPath;
-(NSString*)titleForSection:(NSInteger)section;
-(void)albumsWithUserId:(NSUInteger)userId;
-(void)postsWithUserId:(NSUInteger)userId;
@end
