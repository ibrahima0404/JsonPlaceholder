//
//  UsersViewModel.h
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 17/06/2018.
//  Copyright © 2018 NxApple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiDataProvider.h"

@interface UsersViewModel : NSObject<NSFetchedResultsControllerDelegate>
@property(nonatomic, strong, readwrite) ApiDataProvider *apiDataProvider;

-(instancetype)init;
-(NSUInteger)numberOfRowsInsection:(NSInteger)section;
-(NSString*)titleOfCellAtIndexPath:(NSIndexPath *)indexPath;
-(NSUInteger)userIdAtIndexPath:(NSIndexPath *)indexPath;

@end
