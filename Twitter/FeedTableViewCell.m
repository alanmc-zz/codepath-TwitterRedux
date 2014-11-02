//
//  FeedTableViewCell.m
//  Twitter
//
//  Created by Alan McConnell on 11/2/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface FeedTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;

@end

@implementation FeedTableViewCell

- (void)awakeFromNib {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    NSLog(@"%@", tweet.createdBy);
    self.userNameLabel.text = tweet.createdBy.name;
    self.userHandleLabel.text = [[NSString alloc] initWithFormat:@"@%@", tweet.createdBy.handle];
    self.tweetLabel.text = tweet.text;
    [self.profileImageView setImageWithURL:tweet.createdBy.profileImageURL];
    self.profileImageView.layer.cornerRadius = 12;
    self.profileImageView.clipsToBounds = YES;
    
    NSTimeInterval timeSinceTweet = [[NSDate date] timeIntervalSinceDate:tweet.createdAt];
    
    // Print up to 24 hours as a relative offset
    if(timeSinceTweet < 24.0 * 60.0 * 60.0) {
        NSUInteger hoursSinceTweet = (NSUInteger)(timeSinceTweet / (60.0 * 60.0));
        self.createdAtLabel.text = [NSString stringWithFormat:@"%luh", (unsigned long)hoursSinceTweet];
    } else {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMM/dd/yyyy"];
        self.createdAtLabel.text =  [format stringFromDate:tweet.createdAt];
    }

}

@end
