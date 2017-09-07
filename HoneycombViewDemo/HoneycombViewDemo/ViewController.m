//
//  ViewController.m
//  HoneycombViewDemo
//
//  Created by 杨 on 17/2/5.
//  Copyright © 2017年 杨. All rights reserved.
//

#import "ViewController.h"
#import "HoneycombViewController.h"
#import "HoneycombDefine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)jumpBtnClick:(id)sender {
    HoneycombViewController *honeycombVc = [[HoneycombViewController alloc]init];

    [self.navigationController pushViewController:honeycombVc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
