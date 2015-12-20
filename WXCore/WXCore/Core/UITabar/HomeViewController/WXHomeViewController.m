//
//  WXHomeViewController.m
//  WXCore
//
//  Created by 朱洪伟 on 15/10/21.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXHomeViewController.h"
#import "WXHomeViewDataSource.h"
#import "WSPersistence.h"

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
    self.dataSource = [[WXHomeViewDataSource alloc] init];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsPullToRefresh =YES;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyView.userInteractionEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.frame = CGRectMake(0, 65, self.view.width, self.view.height-65);
    [self.dataSourceArray addObjectsFromArray:[self testRequstData]];

    
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
- (NSString*)testJson
{
    NSString * str = @"{\"array\":[{\"title\":\"测试\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试2\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试3\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试4\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试5\",\"sub_tiel\":\"1\",\"url\":\"\"}],\"string\":\"Hello World\"}";
    return str;
}
@end
