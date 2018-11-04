//
//  UsersTableViewController.h
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 14/06/2018.
//  Copyright © 2018 Ibrahima KH GUEYE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiDataProvider.h"

@interface UsersTableViewController : UITableViewController<UITableViewDataSource>
@property(nonatomic, strong, readwrite) ApiDataProvider *apiDataProvider;
@end
