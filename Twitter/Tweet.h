//
//  Tweet.h
//  Twitter
//
//  Created by Alan McConnell on 11/1/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, assign) NSInteger tweetId;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, strong) User *createdBy;
@property (nonatomic, strong) User *retweetedBy;

@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;

@property (nonatomic, assign) BOOL isRetweet;
@property (nonatomic, assign) BOOL isFavorite;

- (id)initWithDictionary:(NSDictionary*)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
