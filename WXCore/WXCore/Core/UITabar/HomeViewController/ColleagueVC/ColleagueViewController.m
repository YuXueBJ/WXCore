//
//  ColleagueViewController.m
//  WXCore
//
//  Created by 朱洪伟 on 15/11/1.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "ColleagueViewController.h"
#import "ColleagueDataSource.h"

@interface ColleagueViewController ()

@end

@implementation ColleagueViewController

- (void)initializationTableView{
    
    self.dataSource = [[ColleagueDataSource alloc] init];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsPullToRefresh =YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyView.userInteractionEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableView.frame = CGRectMake(0, 65, self.view.width, self.view.height-65);

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializationTableView];
//    [self showEmpty:YES];
    [self showError:YES];
    
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
