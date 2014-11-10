//
//  TwitterClient.m
//  Twitter
//
//  Created by Alan McConnell on 11/1/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

@interface TwitterClient()

@property (nonatomic, weak) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

NSString * const kConsumerKey = @"nFsyNsOemdr3o8nR1wC7oVOjV";
NSString * const kConsumerSecret = @"7zwQUuWSh0nKPkhzpHz09lFZsicgEzC9Xzc5JgmrMWcM6AhTlf";
NSString * const kBaseURL = @"https://api.twitter.com/";

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]
                                                  consumerKey:kConsumerKey
                                               consumerSecret:kConsumerSecret];
        }
    });
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                                    method:@"GET"
                                    callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"]
                                    scope:nil
                                    success:^(BDBOAuthToken *requestToken) {
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
        
    } failure:^(NSError *error) {
        self.loginCompletion(nil, error);
    }];

}

- (void)homeTimelineWithLastId:(NSInteger)lastId completion:(void (^)(NSArray* tweets, NSError *error))completion {
    if ([User currentUser] == nil) {
        completion(nil, [[NSError alloc] initWithDomain:@"twitter" code:404 userInfo:nil]);
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (lastId != 0) {
        [params setValue:[[NSNumber alloc] initWithInteger:lastId] forKey:@"max_id"];
    }
         
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)mentionsWithLastId:(NSInteger)lastId completion:(void (^)(NSArray* tweets, NSError *error))completion {
    if ([User currentUser] == nil) {
        completion(nil, [[NSError alloc] initWithDomain:@"twitter" code:404 userInfo:nil]);
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (lastId != 0) {
        [params setValue:[[NSNumber alloc] initWithInteger:lastId] forKey:@"max_id"];
    }
    
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)profile:(NSInteger)userID withLastId:(NSInteger)lastId completion:(void (^)(User* user, NSArray* tweets, NSError *error))completion {
    if ([User currentUser] == nil) {
        completion(nil, nil, [[NSError alloc] initWithDomain:@"twitter" code:404 userInfo:nil]);
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (lastId != 0) {
        [params setValue:[[NSNumber alloc] initWithInteger:lastId] forKey:@"max_id"];
    }
    
    [self GET:@"1.1/statuses/user_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];

        NSMutableDictionary *userParams = [NSMutableDictionary dictionary];
        [userParams setValue:[[NSNumber alloc] initWithInteger:userID] forKey:@"user_id"];

        [self GET:@"1.1/users/show.json" parameters:userParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            NSLog(@"%@", tweets);
            completion(user, tweets, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completion(nil, nil, error);
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, nil, error);
    }];
}

- (void)retweetId:(NSInteger)tweetId completion:(void (^)(Tweet* tweet, NSError *error))completion {
    if ([User currentUser] == nil) {
        completion(nil, [[NSError alloc] initWithDomain:@"twitter" code:404 userInfo:nil]);
    }
    
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%ld.json", (long)tweetId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)updateStatus:(NSString *)status replyTo:(NSInteger)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    if ([User currentUser] == nil) {
        completion(nil, [[NSError alloc] initWithDomain:@"twitter" code:404 userInfo:nil]);
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:status forKey:@"status"];
    
    if (tweetId != 0) {
        [params setValue:[[NSNumber alloc] initWithInteger:tweetId] forKey:@"in_reply_to_status_id"];
    }
    
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)favoriteStatus:(NSInteger)tweetId completion:(void (^)(NSError *error))completion {
    if ([User currentUser] == nil) {
        completion([[NSError alloc] initWithDomain:@"twitter" code:404 userInfo:nil]);
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[[NSNumber alloc] initWithInteger:tweetId] forKey:@"id"];
    
    [self POST:@"1.1/favorites/create.json"
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(nil);
    }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"%@", error);
        completion(error);
    }];
}

- (void)unfavoriteStatus:(NSInteger)tweetId completion:(void (^)(NSError *error))completion {
    if ([User currentUser] == nil) {
        completion([[NSError alloc] initWithDomain:@"twitter" code:404 userInfo:nil]);
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[[NSNumber alloc] initWithInteger:tweetId] forKey:@"id"];
    
    [self POST:@"1.1/favorites/destroy.json"
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           completion(nil);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           completion(error);
       }];
}

- (void)destroyStatus:(NSInteger)tweetId completion:(void (^)(NSError *error))completion {
    if ([User currentUser] == nil) {
        completion([[NSError alloc] initWithDomain:@"twitter" code:404 userInfo:nil]);
    }
    
    
    [self POST:[NSString stringWithFormat:@"1.1/statuses/destroy/%ld.json", (long)tweetId]
    parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           completion(nil);
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"%@", error);
           completion(error);
       }];
}
- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token"
          method:@"POST"
          requestToken:[BDBOAuthToken tokenWithQueryString:[url query]]
          success:^(BDBOAuthToken *accessToken) {
              [self.requestSerializer saveAccessToken:accessToken];
              [self GET:@"1.1/account/verify_credentials.json"
                    parameters:nil
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        User *user = [[User alloc] initWithDictionary:responseObject];
                        [User setCurrentUser:user];
                        self.loginCompletion(user, nil);
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        self.loginCompletion(nil, error);
                    }];
          }
          failure:^(NSError *error) {
              self.loginCompletion(nil, error);
          }];
}
@end
