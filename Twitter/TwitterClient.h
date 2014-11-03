//
//  TwitterClient.h
//  Twitter
//
//  Created by Alan McConnell on 11/1/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)homeTimelineWithCompletion:(void (^)(NSArray* tweets, NSError *error))completion;
- (void)retweetId:(NSInteger)id completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)updateStatus:(NSString *)status replyTo:(NSInteger)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)favoriteStatus:(NSInteger)tweetId completion:(void (^)(NSError *error))completion;
- (void)unfavoriteStatus:(NSInteger)tweetId completion:(void (^)(NSError *error))completion;

- (void)openURL:(NSURL *)url;

@end
