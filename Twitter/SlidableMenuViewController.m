//
//  SlidableMenuViewController.m
//  Twitter
//
//  Created by Alan McConnell on 11/9/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "SlidableMenuViewController.h"

@interface SlidableMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *contentViewPanGestureRecognizer;

@end

@implementation SlidableMenuViewController

- (id)initWithMenuViewController:(UIViewController<SlidableMenuViewMenuControllerDelegate> *)mvc contentViewController:(UIViewController<SlidableMenuViewContentControllerDelegate> *)cvc {
    self = [super init];
    if (self) {
        _menuViewController = mvc;
        _contentViewController = cvc;
        
        UIImage *image = [[UIImage imageNamed:@"menu-20.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [menuView addSubview:[[UIImageView alloc] initWithImage:image]];
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menuView];
        _contentViewController.navigationItem.leftBarButtonItem = menuButton;
    }
    return self;
}

- (void)onMenuSelect:(NSInteger)selectedItem {
    UINavigationController *nav = (UINavigationController *)self.contentViewController;
    [(UIViewController<SlidableMenuViewContentControllerDelegate> *)nav.topViewController didSelectMenuItem:selectedItem];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect contentFrame = self.contentView.frame;
        CGSize contentSize = contentFrame.size;
        self.contentView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    }];
}

- (IBAction)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {

    CGPoint point = [panGestureRecognizer locationInView:self.view];
    static CGFloat offset;

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        offset = self.contentView.center.x - [panGestureRecognizer locationInView:self.view].x;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.contentView.center = CGPointMake(point.x + offset, self.contentView.center.y);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {

        CGRect contentFrame = self.contentView.frame;
        CGSize contentSize = contentFrame.size;
        if ([panGestureRecognizer velocityInView:self.view].x > 1) {
            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.contentView.frame = CGRectMake(self.view.frame.size.width - 50, 0, contentSize.width, contentSize.height);
            } completion:^(BOOL finished) {
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
            }];
        }
    
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuViewController.view.frame = self.menuView.frame;
    [self.menuView addSubview:self.menuViewController.view];

    self.contentViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.contentViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
