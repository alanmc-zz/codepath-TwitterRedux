//
//  ProfileHeaderTableViewCell.m
//  Twitter
//
//  Created by Alan McConnell on 11/9/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "ProfileHeaderTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;

@end

@implementation ProfileHeaderTableViewCell

- (void)setUser:(User *)user {
    [self.backgroundImage setImageWithURL:user.backgroundImageURL];
    [self.profileImageView setImageWithURL:user.profileImageURL];

    self.nameLabel.text = user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", user.handle];
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%ld", (long)user.tweetCount];
    self.followerCountLabel.text = [NSString stringWithFormat:@"%ld", (long)user.followerCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%ld", (long)user.followingCount];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
