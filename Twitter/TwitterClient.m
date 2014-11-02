//
//  TwitterClient.m
//  Twitter
//
//  Created by Alan McConnell on 11/1/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "TwitterClient.h"

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
