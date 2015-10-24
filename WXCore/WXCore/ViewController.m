//
//  ViewController.m
//  WXCore
//
//  Created by 朱洪伟 on 15/6/30.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "ViewController.h"
#import "ClickedBlockViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedBlockButton:(id)sender {
    
    ClickedBlockViewController * ClickedBlockView = [[ClickedBlockViewController alloc] init];
    [self.navigationController pushViewController:ClickedBlockView animated:YES];
}
@end
