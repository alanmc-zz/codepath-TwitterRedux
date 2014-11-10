//
//  FeedViewController.m
//  Twitter
//
//  Created by Alan McConnell on 11/2/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "FeedViewController.h"
#import "TweetViewController.h"
#import "CreateTweetViewController.h"
#import "FeedTableViewCell.h"
#import "ProfileHeaderTableViewCell.h"
#import "User.h"
#import "TwitterClient.h"
#import "SVProgressHUD.h"

@interface FeedViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, atomic) FeedTableViewCell *currentCell;
@property (strong, atomic) ProfileHeaderTableViewCell *profileCell;

@property (assign, nonatomic) TwitterViewType currentView;
@property (strong, nonatomic) User* profileUser;

@property (strong, atomic) NSMutableArray* tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation FeedViewController

- (void)onProfileSelect:(User *)user {
    [self updateView:TwitterViewTypeProfile withProfileID:user.userID];
}

- (void)didSelectMenuItem:(NSInteger)selectedItem {
    [self updateView:selectedItem withProfileID:[User currentUser].userID];
}

- (void)updateView:(TwitterViewType)viewType withProfileID:(NSInteger)profileID {
    self.currentView = viewType;
    switch (self.currentView) {
        case TwitterViewTypeHomeTimeline:
        {
            self.title = @"Home";
            break;
        }
        case TwitterViewTypeProfile:
        {
            self.title = @"Profile";
            break;
        }
        case TwitterViewTypeMentions:
        {
            self.title = @"Mentions";
            break;
        }
    }
    [self loadTweetsWithTableView:self.tableView
                        startFrom:0
                      clearTweets:YES
                        profileID:profileID];
}

- (void)loadTweetsWithTableView:(UITableView *)tableView
                      startFrom:(NSInteger)fromId
                    clearTweets:(BOOL)clearTweets
                      profileID:(NSInteger)profileID
{
    [SVProgressHUD show];

    switch (self.currentView) {
        case TwitterViewTypeHomeTimeline:
        {
            [[TwitterClient sharedInstance] homeTimelineWithLastId:fromId completion:^(NSArray *tweets, NSError *error) {
                [SVProgressHUD dismiss];
                if (error != nil) {
                    NSLog(@"%@", error);
                } else {
                    if (clearTweets) {
                        self.tweets = [NSMutableArray array];
                    }
                    [self.tweets addObjectsFromArray:tweets];
                    [self.tableView reloadData];
                }
            }];
            break;
        }
        case TwitterViewTypeMentions:
        {
            [[TwitterClient sharedInstance] mentionsWithLastId:fromId completion:^(NSArray *tweets, NSError *error) {
                [SVProgressHUD dismiss];
                if (error != nil) {
                    NSLog(@"%@", error);
                } else {
                    if (clearTweets) {
                        self.tweets = [NSMutableArray array];
                    }
                    [self.tweets addObjectsFromArray:tweets];
                    [self.tableView reloadData];
                }
            }];
            break;
        }
        case TwitterViewTypeProfile:
        {
            [[TwitterClient sharedInstance] profile:profileID withLastId:fromId completion:^(User *user, NSArray *tweets, NSError *error) {
                [SVProgressHUD dismiss];
                if (error != nil) {
                    NSLog(@"%@", error);
                } else {
                    if (clearTweets) {
                        self.tweets = [NSMutableArray array];
                    }
                    self.profileUser = user;
                    [self.tweets addObjectsFromArray:tweets];
                    [self.tableView reloadData];
                }
            }];
            break;
        }
    }
}

- (void)refresh
{
    [self loadTweetsWithTableView:self.tableView
                        startFrom:0
                      clearTweets:YES
                        profileID:[User currentUser].userID];
    [self.refreshControl endRefreshing];
}

- (void)onCreateTweet:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void)onReply:(Tweet *)tweet {
    CreateTweetViewController *ctvc = [[CreateTweetViewController alloc] init];
    ctvc.replyTo = tweet;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:ctvc];
    ctvc.delegate = self;
    
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tweets = [NSMutableArray array];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"FeedTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileHeaderTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"ProfileHeaderTableViewCell"];

    // Configure Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0f/255.0f
                                                                           green:172.0f/255.0f
                                                                            blue:238.0f/255.0f
                                                                           alpha:50.0f/255.0f];
    self.navigationController.navigationBar.translucent = YES;
    
    UIBarButtonItem *createTweetButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(onNewTweet)];
    self.navigationItem.rightBarButtonItem = createTweetButton;
    
    [self updateView:TwitterViewTypeHomeTimeline withProfileID:[User currentUser].userID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentView == TwitterViewTypeProfile) {
        // Reserve a spot for the header cell
        return self.tweets.count + 1;
    } else {
        return self.tweets.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.tweets.count - 1) {
        NSInteger lastId = 0;
        if (self.tweets.count > 0) {
            Tweet *lastTweet = self.tweets.lastObject;
            lastId = lastTweet.tweetId;
        }
        [self loadTweetsWithTableView:self.tableView
                            startFrom:lastId
                          clearTweets:NO
                            profileID:[User currentUser].userID];
    }
    if (self.currentView == TwitterViewTypeProfile && indexPath.row == 0) {
        _profileCell = [self.tableView dequeueReusableCellWithIdentifier:@"ProfileHeaderTableViewCell"];
        return _profileCell;
    } else {
        _currentCell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedTableViewCell"];
        return _currentCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    
    self.currentCell.delegate = self;
    if (self.currentView == TwitterViewTypeProfile) {
        if (indexPath.row == 0) {
            self.profileCell.user = self.profileUser;
            size = [self.profileCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        } else {
            self.currentCell.tweet = self.tweets[indexPath.row - 1];
            size = [self.currentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        }
    } else {
        self.currentCell.tweet = self.tweets[indexPath.row];
        size = [self.currentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    }
    return size.height + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewController *tvc = [[TweetViewController alloc] init];
    tvc.tweet = self.tweets[indexPath.row];
    tvc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onNewTweet {
    CreateTweetViewController *ctvc = [[CreateTweetViewController alloc] init];
    ctvc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:ctvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
