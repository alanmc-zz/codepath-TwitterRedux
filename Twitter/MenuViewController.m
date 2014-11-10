//
//  MenuViewController.m
//  Twitter
//
//  Created by Alan McConnell on 11/9/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "ViewTypes.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Menu";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0f/255.0f
                                                                           green:172.0f/255.0f
                                                                            blue:238.0f/255.0f
                                                                           alpha:50.0f/255.0f];
    self.navigationController.navigationBar.translucent = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 96;

    [self.tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"MenuTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
    switch (indexPath.row) {
        case TwitterViewTypeHomeTimeline:
            cell.menuItemLabel.text = @"Home Timeline";
            [cell.imageView initWithImage:[UIImage imageNamed:@"home.png"]];
            break;
        case TwitterViewTypeProfile:
            cell.menuItemLabel.text = @"Profile";
            [cell.imageView initWithImage:[UIImage imageNamed:@"me.png"]];
            break;
        case TwitterViewTypeMentions:
            cell.menuItemLabel.text = @"Mentions";
            [cell.imageView initWithImage:[UIImage imageNamed:@"mention.png"]];
            break;
        default:
            cell.menuItemLabel.text = @"Sign Out";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case TwitterViewTypeHomeTimeline:
        case TwitterViewTypeProfile:
        case TwitterViewTypeMentions:
            [self.slidableMenuController onMenuSelect:indexPath.row];
            break;
        default:
            [User logout];
            break;
    }
}

@end
