//
//  FeedTableViewCell.m
//  Twitter
//
//  Created by Alan McConnell on 11/2/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "CreateTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import <QuartzCore/QuartzCore.h>

@interface FeedTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;

@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation FeedTableViewCell

- (IBAction)onReply:(id)sender {
    [self.delegate onReply:self.tweet];
}

- (IBAction)onRetweet:(id)sender {
    if (!self.retweetButton.selected) {
        [[TwitterClient sharedInstance] retweetId:self.tweet.tweetId completion:^(Tweet *tweet, NSError *error) {
            if (error == nil) {
                self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tweet.retweetCount + 1];
                self.retweetButton.selected = YES;
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
}

- (IBAction)onFavorite:(id)sender {
    if (!self.favoriteButton.selected) {
        [[TwitterClient sharedInstance] favoriteStatus:self.tweet.tweetId completion:^(NSError *error) {
            if (error == nil) {
                self.favoriteButton.selected = YES;
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tweet.favoriteCount + 1];
            } else {
                NSLog(@"%@", error);
            }
        }];
    } else {
        [[TwitterClient sharedInstance] unfavoriteStatus:self.tweet.tweetId completion:^(NSError *error) {
            if (error == nil) {
                self.favoriteButton.selected = NO;
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tweet.favoriteCount - 1];
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
}

- (void)awakeFromNib {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.userNameLabel.text = tweet.createdBy.name;
    self.userHandleLabel.text = [[NSString alloc] initWithFormat:@"@%@", tweet.createdBy.handle];
    self.tweetLabel.text = tweet.text;
    
    [self.profileImageView setImageWithURL:tweet.createdBy.profileImageURL];
    self.profileImageView.layer.cornerRadius = 12;
    self.profileImageView.clipsToBounds = YES;
    
    self.retweetButton.selected = tweet.isRetweet;
    self.favoriteButton.selected = tweet.isFavorite;
    
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", (long)tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", (long)tweet.favoriteCount];
    
    // Print up to 24 hours as a relative offset
    NSTimeInterval timeSinceTweet = [[NSDate date] timeIntervalSinceDate:tweet.createdAt];

    if(timeSinceTweet < 24.0 * 60.0 * 60.0) {
        NSUInteger minutesSinceTweet = (NSUInteger)(timeSinceTweet / 60.0);
        NSUInteger hoursSinceTweet = (NSUInteger)(minutesSinceTweet / 60.0);

        if (hoursSinceTweet < 1) {
            self.createdAtLabel.text = [NSString stringWithFormat:@"%lum", (unsigned long)minutesSinceTweet];
        } else {
            self.createdAtLabel.text = [NSString stringWithFormat:@"%luh", (unsigned long)hoursSinceTweet];
        }
    } else {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM/dd/yy"];
        self.createdAtLabel.text =  [format stringFromDate:tweet.createdAt];
    }
}

@end
