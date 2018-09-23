//
//  AlbumsTableViewController.m
//  JsonPlaceholder
//
//  Created by Ibrahima KH GUEYE on 14/06/2018.
//  Copyright © 2018 Ibrahima KH GUEYE. All rights reserved.
//

#import "AlbumsTableViewController.h"
#import "DataModel.h"
#import "AlbumsAndPostsViewModel.h"
@interface AlbumsTableViewController () {
    AlbumsAndPostsViewModel *albumsAndPostsViewModel;
}
@end

@implementation AlbumsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    albumsAndPostsViewModel = [[AlbumsAndPostsViewModel alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(arrAlbumsLoaded) name:NsALBUMSSNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(arrPostsLoaded) name:NsPOSTSNOTIFICATION object:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [albumsAndPostsViewModel titleForSection:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [albumsAndPostsViewModel numberOfRowsInSection:section];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    cell.textLabel.text = [albumsAndPostsViewModel titleOfCellAtIndexPath:indexPath];
    return cell;
}

-(void)arrAlbumsLoaded {
    [albumsAndPostsViewModel albumsWithUserId:_userId];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)arrPostsLoaded {
    [albumsAndPostsViewModel postsWithUserId:_userId];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


@end
