//
//  MenuViewController.h
//  Twitter
//
//  Created by Alan McConnell on 11/9/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidableMenuViewController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) SlidableMenuViewController *slidableMenuController;

@end
