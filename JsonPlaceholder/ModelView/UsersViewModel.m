//
//  UsersViewModel.m
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 17/06/2018.
//  Copyright © 2018 NxApple. All rights reserved.
//

#import "UsersViewModel.h"
#import <UIKit/UITableView.h>
#import "DataModel.h"
@interface UsersViewModel()
@property(nonatomic, strong, readonly) DataModel* dataModel;
@end

@implementation UsersViewModel

-(instancetype)initWithDataModel:(DataModel *)dataModel {
    self = [super init];
    if (!self) return nil;
    _dataModel = dataModel;
    return self;
    
}

-(instancetype)init {
    self = [super init];
    if (!self) return nil;
    _dataModel = [DataModel sharedDataModel];
    [_dataModel getUsers];
    return self;
    
}

-(NSUInteger)numberOfRowsInsection:(NSInteger)section {
    return _dataModel.users.count;
}

-(NSString*)titleOfCellAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellTitle = _dataModel.users[indexPath.row][@"name"];
    return cellTitle;
}

-(NSUInteger)userIdAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger userId = [_dataModel.users[indexPath.row][@"id"] integerValue];
    return userId;
}
@end
