//
//  User.m
//  Twitter
//
//  Created by Alan McConnell on 11/1/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLogoutNotif = @"UserDidLogoutNotif";
NSString * const UserDidLoginNotif = @"UserDidLoginNotif";

@interface User()

@property (nonatomic, strong) NSDictionary *userDictionary;

@end

@implementation User

- (id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.userDictionary = dictionary;
    }
    return self;
}

static User *_currentUser = nil;
NSString *kCurrentUserKey = @"kCurrentUserKey";

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)user {
    _currentUser = user;
    
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_currentUser.userDictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotif object:nil];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (void)logout {
    [self setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotif object:nil];
}
@end
