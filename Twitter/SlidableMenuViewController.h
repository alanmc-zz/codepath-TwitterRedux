//
//  SlidableMenuViewController.h
//  Twitter
//
//  Created by Alan McConnell on 11/9/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SlidableMenuViewController : UIViewController

@property (strong, nonatomic) UIViewController *menuViewController;
@property (strong, nonatomic) UIViewController *contentViewController;

- (id)initWithMenuViewController:(UIViewController *)mvc contentViewController:(UIViewController *)cvc;

@end
