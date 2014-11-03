//
//  TweetViewController.m
//  Twitter
//
//  Created by Alan McConnell on 11/2/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "TweetViewController.h"
#import "CreateTweetViewController.h"
#import "TwitterClient.h"

#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetViewController

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

- (IBAction)onReply:(id)sender {
    CreateTweetViewController *ctvc = [[CreateTweetViewController alloc] init];
    ctvc.replyTo = self.tweet;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:ctvc];
    ctvc.delegate = self.delegate;

    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tweet";
    
    self.nameLabel.text = self.tweet.createdBy.name;
    self.handleLabel.text = self.tweet.createdBy.handle;
    self.tweetLabel.text = self.tweet.text;

    [self.profileImageView setImageWithURL:self.tweet.createdBy.profileImageURL];
    self.profileImageView.layer.cornerRadius = 12;
    self.profileImageView.clipsToBounds = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy, hh:mm a"];
    self.createdAtLabel.text = [formatter stringFromDate:self.tweet.createdAt];
    
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.tweet.favoriteCount];

    self.retweetButton.selected = self.tweet.isRetweet;
    self.favoriteButton.selected = self.tweet.isFavorite;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0f/255.0f
                                                                           green:172.0f/255.0f
                                                                            blue:238.0f/255.0f
                                                                           alpha:50.0f/255.0f];
    self.navigationController.navigationBar.translucent = YES;
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onHome)];
    self.navigationItem.leftBarButtonItem = homeButton;
    
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(onReply:)];
    self.navigationItem.rightBarButtonItem = replyButton;
}

- (void)onHome {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
