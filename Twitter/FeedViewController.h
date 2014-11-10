//
//  FeedViewController.h
//  Twitter
//
//  Created by Alan McConnell on 11/2/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateTweetViewController.h"
#import "FeedTableViewCell.h"
#import "ViewTypes.h"
#import "SlidableMenuViewController.h"

@interface FeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CreateTweetViewControllerDelegate, FeedTableViewCellDelegate, SlidableMenuViewContentControllerDelegate>

- (void)didSelectMenuItem:(NSInteger)selectedItem;
- (void)onReply:(Tweet *)tweet;
- (void)onProfileSelect:(User *)user;

@end
