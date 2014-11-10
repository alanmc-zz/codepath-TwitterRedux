//
//  SlidableMenuViewController.h
//  Twitter
//
//  Created by Alan McConnell on 11/9/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlidableMenuViewController;

@protocol SlidableMenuViewContentControllerDelegate <NSObject>

- (void)didSelectMenuItem:(NSInteger)selectedItem;

@end

@protocol SlidableMenuViewMenuControllerDelegate <NSObject>

@property (strong, nonatomic) SlidableMenuViewController *slidableMenuController;

@end

@interface SlidableMenuViewController : UIViewController

@property (strong, nonatomic) UIViewController<SlidableMenuViewMenuControllerDelegate> *menuViewController;
@property (strong, nonatomic) UIViewController<SlidableMenuViewContentControllerDelegate> *contentViewController;

- (id)initWithMenuViewController:(UIViewController *)mvc contentViewController:(UIViewController *)cvc;
- (void)onMenuSelect:(NSInteger)selectedItem;

@end
