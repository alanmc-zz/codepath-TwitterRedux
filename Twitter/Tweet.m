//
//  Tweet.m
//  Twitter
//
//  Created by Alan McConnell on 11/1/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.tweetId = [dictionary[@"id_str"] integerValue];
        self.text = dictionary[@"text"];
        self.createdBy = [[User alloc] initWithDictionary:dictionary[@"user"]];

        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];

        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.favoriteCount = [dictionary[@"favourites_count"] integerValue];

        self.isRetweet = [dictionary[@"retweeted"] boolValue];
        self.isFavorite = [dictionary[@"favorited"] boolValue];
        NSLog(@"%@", dictionary);
        if (dictionary[@"retweeted"]) {
            self.retweetedBy = [[User alloc] initWithDictionary:dictionary[@""]];
        }

    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *tweet in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:tweet]];
    }
    return tweets;
}

@end
