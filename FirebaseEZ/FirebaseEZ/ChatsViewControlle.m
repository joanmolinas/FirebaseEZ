//
//  ChatsViewController.m
//  FirebaseEZ
//
//  Created by Joan Molinas Ramon on 28/12/16.
//  Copyright © 2016 NSBeard. All rights reserved.
//

#import "ChatsViewController.h"
#import "FEZAuth.h"
#import "FEZDatabaseConnector.h"

#define CellIdentifier @"ChatsCellIdentifier"

@interface ChatsViewController () <FEZDatabaseConnectorDelegate>
@property (nonatomic, strong) FEZDatabaseConnector *databaseConnector;
@end

@implementation ChatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.databaseConnector = [[FEZDatabaseConnector alloc] initWithDatabaseName:@"rooms"];
    self.databaseConnector.delegate = self;
    [self.databaseConnector observeWithType:FEZDatabaseEventAddedObject];
    [self.databaseConnector observeWithType:FEZDatabaseEventRemovedObject];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.tableFooterView = [UIView new];
}

- (IBAction)disconnect:(UIBarButtonItem *)sender {
    __weak typeof(self)weakSelf = self;
    [FEZAuth signOutWithSuccessCallback:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"Logout successfully");
        [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failureCallback:^(NSError * _Nullable error) {
        NSLog(@"Signout failure -> %@", error.localizedDescription);
    }];
}

#pragma mark - UITableView Delegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.databaseConnector.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    NSDictionary *message = self.databaseConnector.objects[indexPath.row];
    cell.textLabel.text = [message objectForKey:@"name"];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"chatConversation" sender:indexPath];
}


#pragma mark - FEZDatabaseConnector Delegate
- (void)databaseConnector:(FEZDatabaseConnector *)databaseConnector
          didAddNewObject:(id)object {
    NSLog(@"Database added an object: %@", object);
    [self.tableView reloadData];
}

- (void)databaseConnector:(FEZDatabaseConnector *)databaseConnector
          didRemoveObject:(id)object {
    NSLog(@"Database remove an object: %@", object);
    [self.tableView reloadData];
}

@end
