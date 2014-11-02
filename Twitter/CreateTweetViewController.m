//
//  CreateTweetViewController.m
//  Twitter
//
//  Created by Alan McConnell on 11/2/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "CreateTweetViewController.h"

@interface CreateTweetViewController ()

@end

@implementation CreateTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
