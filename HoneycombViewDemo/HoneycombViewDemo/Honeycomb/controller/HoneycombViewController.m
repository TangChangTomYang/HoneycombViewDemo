//
//  HoneycombViewController.m
//  HoneycombViewDemo
//
//  Created by 杨 on 17/2/5.
//  Copyright © 2017年 杨. All rights reserved.
//

#import "HoneycombViewController.h"
#import "HoneycombView.h"
#import "HoneycombCell.h"

#import "HoneycombDefine.h"

@interface HoneycombViewController ()<HoneycombViewDataSource, HoneycombViewDelegate>

@end

@implementation HoneycombViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    HoneycombView *honeycombView = [[HoneycombView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:honeycombView];
    honeycombView.dataSource = self;
    honeycombView.delegate = self;
    
    self.view.backgroundColor = [UIColor lightGrayColor];//HoneycombColor(55, 55, 55);
    self.title = @"honeycombViewController";
    
    
    [honeycombView reloadData];
    
}

#pragma mark- HoneycombViewDataSource
- (NSUInteger)numberOfCellsInHoneycombView:(HoneycombView *)honeycombView {

    return 500;
}

- (HoneycombCell *)honeycombView:(HoneycombView *)honeycombView cellAtIndex:(NSUInteger)cellIndex{
    
    static NSString *ID = @"honeyCombCell";
    HoneycombCell *honeycell = [honeycombView  dequeueReusableCellWithIdentifier:ID];
    if (honeycell == nil) {
        honeycell =[[HoneycombCell alloc]init];
    
        honeycell.identifier = ID;
      
        honeycell.imgV.image = [UIImage imageNamed:@"bg"];
    }
      honeycell.titleLb.text = [NSString stringWithFormat:@"%03ld",cellIndex];
    return honeycell;
}

- (NSUInteger)columnsInHoneycombView:(HoneycombView *)honeycombView{
    return 6;
}

#pragma mark- HoneycombViewDelegate
/** 有默认的高度，如过没有设置那么高度 通过屏幕的尺寸和最大显示列数 计算*/
-(CGFloat)honeycombView:(HoneycombView *)honeycombView  heightAtIndex:(NSUInteger)cellIndex{
    return 100;

}

-(void)honeycombView:(HoneycombView *)honeycombView didSelectCellAtIndex:(NSUInteger)cellIndex{
    NSLog(@"didSelectCellAtIndex : %ld",cellIndex);
}

-(CGFloat)honeycombView:(HoneycombView *)honeycombView marginForType:(honeycombViewMaginType)MaginType{
    return 2;
}

@end
