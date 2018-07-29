//
//  ViewController.m
//  serverapi
//
//  Created by Vladimir Opanasenko on 10.04.2018.
//  Copyright © 2018 Vladimir Opanasenko. All rights reserved.
//

#import "ViewController.h"
#import "ServerManager.h"
#import "Friend.h"
#import "UIImageView+AFNetworking.h"
#import "CoreDataManager.h"
#import "FriendEntity+CoreDataClass.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray <FriendEntity *> *friends;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.friends = [NSMutableArray array];
    [self executeFriends];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- API

- (void)getFriends {
    [[ServerManager sharedManager] getFriendsWithOffset:self.friends.count
                                                  count:30
                                              onSuccess:^(NSArray *friends) {
                                                  [self executeFriends];
                                              } onFailure:^(NSError *error) {
                                                  NSLog(@"%@", [error localizedDescription]);
                                              }];
}

- (void)executeFriends {
    NSManagedObjectContext *managedObjectContext = [[CoreDataManager sharedManager] context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"FriendEntity" inManagedObjectContext:managedObjectContext]];
//    NSString *name = @"Andrey";
//    [request setPredicate:[NSPredicate predicateWithFormat:@"firstName like %@", name]];
    self.friends = [managedObjectContext executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

#pragma mark- UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    if (indexPath.row == self.friends.count) {
        cell.textLabel.text = @"LOAD MORE";
        cell.imageView.image = nil;
    } else {
        FriendEntity *friend = [self.friends objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: friend.imageURL]];
        __weak UITableViewCell *weakCell = cell;
        
        [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            weakCell.imageView.image = image;
            [weakCell layoutSubviews];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            weakCell.imageView.image = nil;
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.friends.count) {
        [self getFriends];
    }
}

@end
