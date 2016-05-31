//
//  WXHomeViewController.m
//  WXCore
//
//  Created by 朱洪伟 on 15/10/21.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXHomeViewController.h"
#import "WXHomeViewDataSource.h"
#import "WXHomeTableViewItem.h"
#import "WXHomeTableViewObject.h"
#import "ColleagueViewController.h"

@interface WXHomeViewController ()
@property (nonatomic,assign)NSInteger requestPage;
@property (nonatomic,strong)NSMutableArray * dataSourceArray;
@end

@implementation WXHomeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"首页";

    self.dataSource = [[WXHomeViewDataSource alloc] init];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsPullToRefresh =YES;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyView.userInteractionEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.frame = CGRectMake(0, 65, self.view.width, self.view.height-65);
    

    [self.dataSourceArray addObjectsFromArray:[self testRequstData]];
    [self requestData:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)emptyViewButtonAction
{
    [self pullToRefreshAction];
}
-(void)pullToRefreshAction{
    
    if (self.loadingData) {
        return;
    }
    [self showEmpty:NO];
    [self showError:NO];
    [self startRefreshAction];
    self.loadingData = YES;
    [self requestData:0];
}
- (void)loadMoreAction
{
    if (self.loadingData) {
        return;
    }
    self.loadingData=YES;
    [self requestData:1];
}
-(void)requestData:(NSInteger)type
{
    if (type==0) {
        self.requestPage=1;
    }else{
        self.requestPage++;
    }
    
    //{
    /**
     请求完成执行
     */
    [self stopRefreshAction];
    [self setLoadingData:NO];
    
    if ([self.dataSourceArray count]==0) {
         [self showEmpty:YES];
    }else{
        [self showEmpty:NO];
    }
    //RequestSuccess
    if (/* DISABLES CODE */ (1)) {
        [(WXHomeViewDataSource*)self.dataSource reloadHomeTableViewData:self.dataSourceArray];
        [self.tableView reloadData];
    }else{
        [(WXHomeViewDataSource*)self.dataSource reloadHomeTableViewData:nil];
        [self showError:YES];
        [self.tableView reloadData];
    }
    //}
    
}
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WXHomeTableViewItem * item = (WXHomeTableViewItem*)object;
    WXHomeTableViewObject * data = item.home_Object;
    
    switch (data.inputStype) {
        case HomeTableViewStyle_Colleague:{
            
            ColleagueViewController * colleagyeVC = [[ColleagueViewController alloc] init];
            [self.navigationController pushViewController:colleagyeVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (NSMutableArray*)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}
- (NSArray*)testRequstData
{
    NSString * reson = [self testJson];
    NSData* data = [reson dataUsingEncoding:NSUTF8StringEncoding];
    
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error];
    NSLog(@"%@",result);
    NSDictionary * ar = (NSDictionary*) result;
    NSArray * list = [ar objectForKey:@"array"];
    
    return list;
}
- (NSString*)testJson{
    
    NSString * str = @"{\"array\":[{\"title\":\"通讯录\",\"sub_title\":\"通讯录显示添加编辑\",\"imgUrl\":\"\",\"sub_Type\":1},{\"title\":\"测试\",\"sub_title\":\"通讯录显示添加编辑\",\"imgUrl\":\"\",\"sub_Type\":1},{\"title\":\"测试\",\"sub_title\":\"通讯录显示添加编辑\",\"imgUrl\":\"\",\"sub_Type\":1}],\"string\":\"Hello World\"}";
    
    return str;
/*
 
 {
 "array": [
 {
 "title": "通讯录",
 "sub_title": "通讯录显示添加编辑",
 "imgUrl": "",
 "sub_Type":1
 },
 {
 "title": "测试",
 "sub_title": "通讯录显示添加编辑",
 "imgUrl": "",
 "sub_Type":1
 },
 {
 "title": "测试",
 "sub_title": "通讯录显示添加编辑",
 "imgUrl": "",
 "sub_Type":1
 }
 ],
 "string": "Hello World"
 }
 
 */
}
@end
