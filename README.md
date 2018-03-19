## 什么是WXCore？
在用户开发 app 页面时经常遇到需要自定义 cell 的情况

## WXCore有哪些功能
####1:支持tableview 中Cell(xib, 纯手工打造cell)的自定义,
####2:下拉加载,上拉更多,
####3:请求数据为空情况展示空页面.
####4:请求数据出错情况展示错误页面并提供点击重写加载.
####4:请求数据出错情况展示错误页面并提供点击重写加载.

## WXCore库主要类需要继承使用
###1.WXTableViewController 	
tableView控制器

* 类中重新主要方法

  1. ```- (void)emptyViewButtonAction``` 页面第一次请求到空数据需要点击页面重新加载按钮回调
  2. ```- (void)pullToRefreshAction``` 下拉刷新回调方法
  3. ```- (void)loadMoreAction``` 上拉加载更多回调方法
	
###WXTableViewDataSource
* 类中重新主要方法
	1. ```-(Class)tableView:(UITableView *)tableView cellClassForObject:(id)object``` 返回自定义 cell 类
	2. ```- (NSString*)titleForEmpty``` 显示空页面时提示语标题
	3. ```- (BOOL)buttonExecutable``` 显示空页面时是否需要点击重试按钮 默认为 NO
	4. ```- (NSString*)subtitleForEmpty``` 显示空页面时提示语说明
	5. ```- (UIImage*)imageForEmpty``` 显示空页面时需要展示的图片
	6. ```- (BOOL)buttonErrorExecutable``` 显示错误页面时是否需要点击重试按钮 默认为 NO
	7. ```- (NSString*)titleForError:(NSError*)error``` 显示错误页面时需要展示的图片
	8. ```- (UIImage*)imageForError:(NSError*)error``` 显示错误页面时需要展示的图片
	
###WXTableViewItem 
	用于cell高度记录防止多次计算cell高度引起性能降低
	
###WXTableViewCell
	用于自定义cell
* 类中重新主要方法
	1. ```+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object ``` 返回 cell 高度 
 	2. ```+ (BOOL)isNibOrCored``` cell 是否为 xib
 	3. ```+ (BOOL)isCacheCell``` cell 是否需要缓存
 	4. ```- (void)setObject:(id)object``` cell 需要的数据(model)



#如何使用

## 1. WXTableViewController.h
```
#import "WXCode.h"

@interface WXViewController : WXTableViewController

@end
```	

## 2. WXTableViewController.m
```	
#import "WXHomeViewDataSource.h"


@interface WXViewController ()
@property (nonatomic,assign)NSInteger requestPage;
@property (nonatomic,strong)NSMutableArray * dataSourceArray;
@end

@implementation WXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.dataSource = [[WXHomeViewDataSource alloc] init];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.showsPullToRefresh = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyView.userInteractionEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.frame = CGRectMake(0, 65, self.view.width, self.view.height-65);
    [self.dataSourceArray addObjectsFromArray:[self testRequstData]];
    [self showEmpty:YES];
}

- (void)didReceiveMemoryWarning
{
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
//    [self startRefreshAction];
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
        //{
        /**
         请求完成执行
         */
        [self stopRefreshAction];
        [self setLoadingData:NO];
        [self showError:NO];
        if ([self.dataSourceArray count]==0) {
            [self showEmpty:YES];
        }else{
            [self showEmpty:NO];
        }
    }else{
        self.requestPage++;
    }
    //RequestSuccess
    if (type==0) {
        [(WXHomeViewDataSource*)self.dataSource reloadHomeTableViewData:self.dataSourceArray];
        [self.tableView reloadData];
    }else{
        [self performSelector:@selector(reloadMoreData) withObject:nil afterDelay:3];
    }
    //}
    
}
- (void)reloadMoreData
{
    [self stopRefreshAction];
    [self setLoadingData:NO];
    [self showError:NO];
    [self showEmpty:NO];
    [(WXHomeViewDataSource*)self.dataSource reloadMoreTableViewData:self.dataSourceArray];
    [self.tableView reloadData];
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
    NSString * str = @"{\"array\":[{\"title\":\"测试\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试2\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试3\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试4\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试5\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试2\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试3\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试4\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试5\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试2\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试3\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试4\",\"sub_tiel\":\"1\",\"url\":\"\"},{\"title\":\"测试5\",\"sub_tiel\":\"1\",\"url\":\"\"}],\"string\":\"Hello World\"}";
    return str;
}
```	

## 3. WXHomeViewDataSource.h
```	
#import "WXCode.h"

@interface WXHomeViewDataSource : WXTableViewSectionedDataSource

- (void)reloadHomeTableViewData:(NSArray*)dataList;
- (void)reloadMoreTableViewData:(NSArray*)dataList;
@end
```	

## 4. WXHomeViewDataSource.m

```	
#import "WXHomeViewDataSource.h"
#import "WXHomeTableViewCell.h"
#import "WXHomeTableViewItem.h"

#define kCountPerPage 10

@implementation WXHomeViewDataSource

-(Class)tableView:(UITableView *)tableView cellClassForObject:(id)object
{
    if ([object isKindOfClass:[WXHomeTableViewItem class]]) {
        return [WXHomeTableViewCell class];
    }
    return [super tableView:tableView cellClassForObject:object];
}

- (void)reloadHomeTableViewData:(NSArray*)dataList
{
    WXTableViewSectionObject *firstSectionObj = [[WXTableViewSectionObject alloc] init];
    for (NSDictionary *dic  in dataList) {
        WXHomeTableViewItem * item=[[WXHomeTableViewItem alloc] initWithObject:dic];
        [firstSectionObj.items addObject:item];
    }
    self.sections = [NSMutableArray arrayWithObjects:firstSectionObj, nil];
    if ([dataList count]>=kCountPerPage) {
        WXTableViewSectionObject * loadmore=[[WXTableViewSectionObject alloc] init];
        WXTableViewLoadMoreItem *moreItem = [[WXTableViewLoadMoreItem alloc] init];
        [loadmore.items addObject:moreItem];
        [self.sections addObject:loadmore];
    }
}
- (void)reloadMoreTableViewData:(NSArray*)dataList
{
    WXTableViewSectionObject * firstSectionObj=[self.sections objectAtIndex:0];
    for (NSDictionary *dic  in dataList) {
        WXHomeTableViewItem * item=[[WXHomeTableViewItem alloc] initWithObject:dic];
        [firstSectionObj.items addObject:item];
    }
    if ([dataList count]<kCountPerPage) {
        [self.sections removeObjectAtIndex:1];
    }
}
- (NSString*)titleForEmpty {
    return @"点击重新刷新...";
}
- (BOOL)buttonExecutable{
    return YES;
}
- (BOOL)buttonErrorExecutable{
    return YES;
}
- (NSString*)subtitleForEmpty {
    return @"没有数据...";
}
- (UIImage*)imageForEmpty {
    return [UIImage imageNamed:@"coffee_cup_empty"];
}
- (NSString*)titleForError:(NSError*)error {
    return @"加载出错";
}
- (UIImage*)imageForError:(NSError*)error {
    return [UIImage imageNamed:@"404Error"];
}

@end
```	

## 5. WXHomeTableViewCell.h
```	
#import "WXCode.h"

@interface WXHomeTableViewCell : WXTableViewCell
@property (strong, nonatomic) UIImageView *titleImageVIew;

@property (strong, nonatomic) UILabel * titleLable;

@property (strong, nonatomic) UILabel *subTitleLable;

@end
```

## 6. WXHomeTableViewCell.m
```
#import "WXTableViewItem.h"
#import "WXHomeTableViewItem.h"
#import "WXHomeTableViewObject.h"

#define kLineBackColor                  RGBCOLOR(207, 207,207);    

@interface WXHomeTableViewCell ()
@property (nonatomic,strong)UILabel * lineLable;

@end

@implementation WXHomeTableViewCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    
    WXTableViewItem *item = (WXTableViewItem *)object;
    if (item.cellHeight) {
        return item.cellHeight;
    }
    //Cell区域高度
    CGFloat infoAreaHeight = 50;
    
    return infoAreaHeight;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLable = [ViewCreatorHelper createLabelWithTitle:nil font:[UIFont systemFontOfSize:16.0f] frame:CGRectZero textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLable];
        
        self.lineLable = [ViewCreatorHelper createLabelWithTitle:nil font:[UIFont systemFontOfSize:12] frame:CGRectZero textColor:[UIColor grayColor] textAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.lineLable];
        self.lineLable.backgroundColor=kLineBackColor;
    }
    return self;
}
- (void)setObject:(id)object {
    [super setObject:object];
    if (!object) {
        return;
    }
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    WXHomeTableViewItem * item = (WXHomeTableViewItem*)object;
    WXHomeTableViewObject * data = item.home_Object;
    self.titleLable.text = data.title;
    self.subTitleLable.text = data.subTitle;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
+ (BOOL)isNibOrCored{
    return NO;
}
+ (BOOL)isCacheCell{
    return NO;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
   self.titleLable.frame = CGRectMake(30, 10, self.width-40, 20);
    self.lineLable.frame = CGRectMake(0, self.height - 1, self.width, 0.5);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
```
	
## 7. WXHomeTableViewItem
####.h

```
@class WXHomeTableViewObject;
@interface WXHomeTableViewItem : WXTableViewItem
@property (nonatomic,strong)WXHomeTableViewObject * home_Object;
- (instancetype)initWithObject:(NSDictionary*)json;
-(instancetype)initWithReadJson:(WXHomeTableViewObject *)dbData;
@end

```
####.m

```
#import "WXHomeTableViewItem.h"
#import "WXHomeTableViewObject.h"

@implementation WXHomeTableViewItem

- (instancetype)initWithObject:(NSDictionary*)json;
{
    self = [super init];
    if (self) {
        if (json) {
            self.home_Object=[[WXHomeTableViewObject alloc] initWithJson:json];
            //数据存储
//            [APPCONTEXT.campService saveCampistData:self.hotgirlData];
        }
    }
    return self;
}

-(instancetype)initWithReadJson:(WXHomeTableViewObject *)dbData
{
    self = [super init];
    if (self) {
        if (dbData) {
            self.home_Object=dbData;
        }
    }
    return self;
}

@end

```

## 8. WXHomeTableViewObject
####.h

```

typedef NS_ENUM(NSInteger, HomeTableViewStyle) {
    HomeTableViewStyleNone,
    HomeTableViewStyle_Colleague,
    HomeTableViewStyle_Other,
    HomeTableViewStyleDefault NS_ENUM_AVAILABLE_IOS(7_0)
};

@interface WXHomeTableViewObject : NSObject

@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSString * subTitle;
@property (nonatomic,strong)NSString * imageUrl;
@property (nonatomic,assign)HomeTableViewStyle inputStype;

-(instancetype)initWithJson:(NSDictionary*)object;
@end

```

####.m


```

#import "WXHomeTableViewObject.h"

@implementation WXHomeTableViewObject
-(instancetype)initWithJson:(NSDictionary*)object{
    self = [super init];
    if (self) {
        self.title = [object objectForKey:@"title"];
        self.subTitle = [object objectForKey:@"sub_title"];
        self.imageUrl = [object objectForKey:@"imgUrl"];
        
        NSNumber * temp = [object objectForKey:@"sub_Type"];
        self.inputStype = [temp integerValue];
    }
    return self;
}
@end

```