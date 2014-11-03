//
//  CreateTweetViewController.h
//  Twitter
//
//  Created by Alan McConnell on 11/2/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol CreateTweetViewControllerDelegate <NSObject>

- (void)onCreateTweet:(Tweet *)tweet;

@end

@interface CreateTweetViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) Tweet* replyTo;
@property (nonatomic, weak) id<CreateTweetViewControllerDelegate> delegate;

@end
