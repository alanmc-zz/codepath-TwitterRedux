//
//  FeedTableViewCell.m
//  Twitter
//
//  Created by Alan McConnell on 11/2/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface FeedTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;

@end

@implementation FeedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWithTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.userNameLabel.text = tweet.createdBy.name;
    self.userHandleLabel.text = tweet.createdBy.handle;
    self.tweetLabel.text = tweet.text;
}

@end
