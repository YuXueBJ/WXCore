//
//  ViewController.m
//  TestPersistence
//
//  Created by 朱洪伟 on 15/12/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import "ViewController.h"
#import "AppContext.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AppContext * appcontext = [AppContext sharedInstance];
    
    [appcontext createDatabaseFiled];
    
    NSArray * dataList = [self testArray];
    for (int i = 0 ; i<[dataList count]; i++) {
        NSDictionary * dic = [dataList objectAtIndex:i];
        HomeDataObject * homeObjc = [[HomeDataObject alloc] initWithJson:dic];
        [appcontext.homeDataSave saveHomeDataList:homeObjc];
    }
    NSArray * dbList = [appcontext.homeDataSave getAllHomeListData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*)testArray
{
    NSString * reson = [self testJosn];
    NSData* data = [reson dataUsingEncoding:NSUTF8StringEncoding];
    
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&error];
    NSLog(@"%@",result);
    NSArray * ar = [(NSDictionary*) result objectForKey:@"array"];
    return ar;
}
- (NSString*)testJosn
{
    NSString * str = @"{\"array\":[{\"name\":\"a\",\"id\":\"1\",\"text\":\"dfajhdks\"},{\"name\":\"b\",\"id\":\"2\",\"text\":\"xkljfd\"},{\"name\":\"a\",\"id\":\"3\",\"text\":\"iofdkf\"}]}";
    return str;
}

@end
