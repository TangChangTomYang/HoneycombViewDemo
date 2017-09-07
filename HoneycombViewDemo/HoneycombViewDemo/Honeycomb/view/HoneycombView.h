//
//  HoneycombView.h
//  HoneycombViewDemo
//
//  Created by 杨 on 17/2/5.
//  Copyright © 2017年 杨. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  defaultColumnCount 3  //默认最大列数 
#define  defaultColumnMargin   3  //默认列间距
#define  defaultRowMargin      3  //默认行间距
typedef enum {
    honeycombViewMaginType_column,//列间距
    honeycombViewMaginType_row//行间距
}honeycombViewMaginType;

@class HoneycombView,HoneycombCell;


//数据源协议
@protocol HoneycombViewDataSource <NSObject>

@required

/** 获取一共有多少个 cell 总数*/
- (NSUInteger)numberOfCellsInHoneycombView:(HoneycombView *)honeycombView ;

/** 获取指定索引位置的 cell*/
- (HoneycombCell *)honeycombView:(HoneycombView *)honeycombView cellAtIndex:(NSUInteger)cellIndex;

@optional
/** 列数至少是3，如果小于3个取3个*/
- (NSUInteger)columnsInHoneycombView:(HoneycombView *)honeycombView;

@end

//代理协议
@protocol HoneycombViewDelegate <UIScrollViewDelegate> //这样比较巧妙
@optional
/** 有默认的高度，如过没有设置那么高度 通过屏幕的尺寸和最大显示列数 计算*/
-(CGFloat)honeycombView:(HoneycombView *)honeycombView  heightAtIndex:(NSUInteger)cellIndex;

-(void)honeycombView:(HoneycombView *)honeycombView didSelectCellAtIndex:(NSUInteger)cellIndex;

-(CGFloat)honeycombView:(HoneycombView *)honeycombView marginForType:(honeycombViewMaginType)MaginType;

@end

@interface HoneycombView : UIScrollView

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,weak)id<HoneycombViewDataSource> dataSource;
@property(nonatomic,weak)id<HoneycombViewDelegate> delegate;


/** 刷新数据*/
-(void)reloadData;

//根据标识符去缓存池中去cell
-(HoneycombCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
