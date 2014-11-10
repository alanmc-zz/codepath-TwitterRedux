//
//  FeedTableViewCell.h
//  Twitter
//
//  Created by Alan McConnell on 11/2/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol FeedTableViewCellDelegate <NSObject>

- (void)onReply:(Tweet *)tweet;
- (void)onProfileSelect:(User *)user;

@end

@interface FeedTableViewCell : UITableViewCell

@property (nonatomic, strong) Tweet* tweet;
@property (nonatomic, weak) id<FeedTableViewCellDelegate> delegate;

@end
