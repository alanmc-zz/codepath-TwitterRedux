//
//  TweetViewController.h
//  Twitter
//
//  Created by Alan McConnell on 11/2/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "CreateTweetViewController.h"

@interface TweetViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<CreateTweetViewControllerDelegate> delegate;

@end
