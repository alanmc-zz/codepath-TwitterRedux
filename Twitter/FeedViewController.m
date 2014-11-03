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
#import "User.h"
#import "TwitterClient.h"
#import "SVProgressHUD.h"

@interface FeedViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, atomic) FeedTableViewCell *currentCell;
@property (strong, atomic) NSMutableArray* tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation FeedViewController

- (void)clearTweets {
    self.tweets = [NSMutableArray array];
}

- (void)loadTweets {
    [[TwitterClient sharedInstance] homeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        } else {
            [self.tweets addObjectsFromArray:tweets];
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
    }];
}

- (void)refresh
{
    [SVProgressHUD show];
    [self clearTweets];
    [self loadTweets];
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
    self.title = @"Home";

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"FeedTableViewCell"];

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
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(onLogout)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    UIBarButtonItem *createTweetButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(onNewTweet)];
    self.navigationItem.rightBarButtonItem = createTweetButton;
    
    [self loadTweets];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentCell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedTableViewCell"];
    return _currentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentCell.delegate = self;
    self.currentCell.tweet = self.tweets[indexPath.row];
    CGSize size = [self.currentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewController *tvc = [[TweetViewController alloc] init];
    tvc.tweet = self.tweets[indexPath.row];
    tvc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onLogout {
    [User logout];
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
