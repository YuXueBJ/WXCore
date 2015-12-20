//
//  AppContext.h
//  TestPersistence
//
//  Created by 朱洪伟 on 15/12/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSPersistenceContext.h"
#import "HomeDataSave.h"

@interface AppContext : NSObject

@property (nonatomic, strong) WSPersistenceContext  * homeDataPersistenceContext;
@property (nonatomic, strong) HomeDataSave * homeDataSave;

+ (AppContext*)sharedInstance;
- (void)createDatabaseFiled;
@end
