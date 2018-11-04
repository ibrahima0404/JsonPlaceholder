//
//  UsersTableViewController.m
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 14/06/2018.
//  Copyright © 2018 Ibrahima KH GUEYE. All rights reserved.
//

#import "UsersTableViewController.h"
#import "AlbumsTableViewController.h"
#import "UsersViewModel.h"

@interface UsersTableViewController (){
    UsersViewModel *usersViewModel;    
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation UsersTableViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    usersViewModel = [[UsersViewModel alloc] init];
    [usersViewModel.apiDataProvider fetchUsers:^(NSError *error) {
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(arrUsersLoaded) name:NsUSERSNOTIFICATION object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [usersViewModel numberOfRowsInsection:0];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [usersViewModel titleOfCellAtIndexPath:indexPath];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"segueToAlbumsVc"]) {
        AlbumsTableViewController *destVC = [[AlbumsTableViewController alloc] init];
        destVC = segue.destinationViewController;
        NSIndexPath *indexPath = (self.tableView).indexPathForSelectedRow;
        NSInteger userId = [usersViewModel userIdAtIndexPath:indexPath];
        destVC.userId = userId;
    }
}

-(void)arrUsersLoaded {
    
    self.title = @"Users";
    //[_spinner setHidden:YES];
    //[_spinner stopAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
