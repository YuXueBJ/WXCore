//
//  WXColleagueDataSource.m
//  WXCore
//
//  Created by 朱洪伟 on 15/11/1.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "ColleagueDataSource.h"

@implementation ColleagueDataSource

- (NSString*)titleForEmpty {
    return @"通讯录为空...";
}
- (NSString*)subtitleForEmpty {
    return @"添加通讯录";
}
- (UIImage*)imageForEmpty {
    return [UIImage imageNamed:@"coffee_cup_empty"];
}
- (BOOL)buttonExecutable{
    return YES;
}

- (NSString*)titleForError:(NSError*)error {
    return @"加载出错";
}
- (UIImage*)imageForError:(NSError*)error {
    return [UIImage imageNamed:@"404Error"];
}
@end
