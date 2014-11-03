//
//  CreateTweetViewController.m
//  Twitter
//
//  Created by Alan McConnell on 11/2/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "CreateTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "TwitterClient.h"
#import "SVProgressHUD.h"

#import <QuartzCore/QuartzCore.h>

@interface CreateTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetInput;

@property (strong, nonatomic) UILabel *charCountLabel;
@property (strong, nonatomic) UIButton *tweetButton;

@end

@implementation CreateTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User *user = [User currentUser];
    self.nameLabel.text = user.name;
    self.handleLabel.text = user.handle;
    
    [self.profileImageView setImageWithURL:user.profileImageURL];
    self.profileImageView.layer.cornerRadius = 12;
    self.profileImageView.clipsToBounds = YES;
    
    self.tweetInput.delegate = self;
    if (self.replyTo != nil) {
        self.tweetInput.text = [NSString stringWithFormat:@"@%@", self.replyTo.createdBy.handle];
    }
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIView *tweetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    
    _charCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _charCountLabel.text = @"140";
    
    _tweetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _tweetButton.enabled = NO;
    _tweetButton.frame = CGRectMake(40, 0, 40, 40);
    [_tweetButton addTarget:self action:@selector(onTweet) forControlEvents:UIControlEventTouchUpInside];
    [_tweetButton setTitle:@"Tweet" forState:UIControlStateNormal];

    [tweetView addSubview:_charCountLabel];
    [tweetView addSubview:_tweetButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tweetView];
    
    
    [self.tweetInput becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    int charRemaining = (int)(140 - textView.text.length);
    _charCountLabel.text = [NSString stringWithFormat:@"%d", charRemaining];
    
    if (charRemaining < 0) {
        _charCountLabel.tintColor = [UIColor redColor];
    } else {
        _charCountLabel.tintColor = [UIColor blackColor];
    }
    
    if (charRemaining < 0 || textView.text.length <= 0) {
        _tweetButton.enabled = NO;
    } else {
        _tweetButton.enabled = YES;
    }
}

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweet {
    [SVProgressHUD show];
    
    NSInteger replyTo = 0;
    if (self.replyTo != nil) {
        replyTo = self.replyTo.tweetId;
    }
    
    [[TwitterClient sharedInstance] updateStatus:self.tweetInput.text replyTo:replyTo completion:^(Tweet *tweet, NSError *error) {
        [SVProgressHUD dismiss];
        if (error == nil) {
            [self.delegate onCreateTweet:tweet];
        } else {
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
