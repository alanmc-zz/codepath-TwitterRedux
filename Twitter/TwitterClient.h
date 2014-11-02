//
//  TwitterClient.h
//  Twitter
//
//  Created by Alan McConnell on 11/1/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

@end
