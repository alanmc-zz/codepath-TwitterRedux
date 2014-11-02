//
//  User.h
//  Twitter
//
//  Created by Alan McConnell on 11/1/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLogoutNotif;
extern NSString * const UserDidLoginNotif;

@interface User : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* handle;
@property (nonatomic, strong) NSURL* profileImageURL;

- (id)initWithDictionary:(NSDictionary*)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
+ (void)logout;

@end
