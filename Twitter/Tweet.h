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

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSDate* createdAt;

@property (nonatomic, strong) User* createdBy;
@property (nonatomic, strong) User* retweetedBy;

- (id)initWithDictionary:(NSDictionary*)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
