//
//  HoneycombView.m
//  HoneycombViewDemo
//
//  Created by 杨 on 17/2/5.
//  Copyright © 2017年 杨. All rights reserved.
//

#import "HoneycombView.h"
#import "HoneycombCell.h"

@interface HoneycombView ()

/**记录所有cell 的frame*/
@property(nonatomic, strong)NSMutableArray *cellFrames;
/**在屏幕中正在显示的cell*/
@property(nonatomic, strong)NSMutableDictionary *displayingCells;
/**可以重用的cell*/
@property(nonatomic, strong)NSMutableSet *reuseableCells;
@end

@implementation HoneycombView

-(NSMutableArray *)cellFrames{
    if (!_cellFrames) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

-(NSMutableDictionary *)displayingCells{
    if (!_displayingCells) {
        _displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

-(NSMutableSet *)reuseableCells{
    if (!_reuseableCells) {
        _reuseableCells = [NSMutableSet set];
    }
    return _reuseableCells;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureTapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

//scroll 滚动的时候会调用这个方法
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //scroll 滚动的时候会调用这个方法
    
    //技巧， 在滚动时向自己的数据源索要cell
    NSUInteger cellCount = [self.dataSource numberOfCellsInHoneycombView:self];
    
    for (int i = 0 ; i < cellCount ; i++) {
        //1. 取出 i 索引位置的frame
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        
        //2. 先从字典中去取 索引对应的cell
        HoneycombCell *honeyCell = self.displayingCells[@(i)];
        //3. 判断 i 索引位置的frame 在不在屏幕上
        if ([self isFrameInScreen:cellFrame]) {
            
            
            if (honeyCell == nil) {
                honeyCell = [self.dataSource honeycombView:self cellAtIndex:i];
                honeyCell.frame = cellFrame;
                [self addSubview:honeyCell];
                self.displayingCells[@(i)] = honeyCell;
            }
            
        }else{//不在屏幕
            if (honeyCell != nil) {//说明该cell 已经滑出了屏幕
                //4. 从屏幕上移除
                [honeyCell removeFromSuperview];
                //5.从当前正在显示的字典中移除
                [self.displayingCells removeObjectForKey:@(i)];
                
                //6.将这个cell 添加到缓存池中
                [self.reuseableCells addObject:honeyCell];
            }
            
        }
    }
    
}

/*
 6边形宽高比
 为w:h = gen号3 ： 2
 
 6边形三角形的高 宽比：
 h: w = 1: 2倍gen号3
 
 6边形小三角形的高 h:w = 1: 2倍gen号3
 
 */

#pragma  mark - 公有方法
/** 重新刷新数据*/
-(void)reloadData{

    //1. 获取cell 的总数
    NSUInteger cellCount = [self.dataSource numberOfCellsInHoneycombView:self];
    //2. 获取cell 的列数
    NSUInteger columnCount = [self columnCount];
    //2.1 最大的列数
     NSUInteger maxColumnCount = columnCount + 1;
    
    //3. 获取cell 的列间距
    CGFloat columnMargin = [self columnMargin];
    //4. 获取cell 的行间距
    CGFloat rowMargin = [self rowMargin];
    //5. 计算cell 的宽度
    CGFloat cellWidth = [self cellWidehWithColumMargin:columnMargin columnCount:columnCount];
    CGFloat cellHeight = (cellWidth *2) / 1.732;
    //6. 计算 cell frame
    NSUInteger perGroupCellCount = 2*columnCount + 1;
    
    CGFloat triangle_h = cellWidth / (3.464);
    
       for (int i = 0; i< cellCount; i++) {
        
        //每7个为一组
        NSUInteger groupIndex = i / perGroupCellCount;
        CGFloat group_y = groupIndex * (2 * (cellHeight + rowMargin)) ;
        
        

        
        NSUInteger indexInGroupCount = i % perGroupCellCount;
        CGRect cellFrame = CGRectZero ;
        
        //NSLog(@"groupIndex:%ld,indexInGroupCount:%ld,w:%f,h:%f",groupIndex,indexInGroupCount,cellWidth,cellHeight);

        CGFloat offset_xDelta = 0 ;
        CGFloat y = 0;
        CGFloat x = 0;
           
           NSInteger rowIndex = groupIndex * 2;//行号
        if (indexInGroupCount < maxColumnCount) {
            offset_xDelta = 0.5*rowMargin + 0.5 * cellWidth;

             y = group_y ;

            x = indexInGroupCount * (cellWidth + rowMargin) + 0.5* rowMargin - offset_xDelta;
        }else{
            rowIndex += 1;
             x = (indexInGroupCount - (columnCount + 1))* (cellWidth + rowMargin) + 0.5* rowMargin - offset_xDelta;
             y = group_y + cellHeight + rowMargin ;
        }
        
           cellFrame =  CGRectMake(x, y ,cellWidth, cellHeight);
        if (i >= maxColumnCount) {
            
             cellFrame =  CGRectMake(x, y - rowIndex * triangle_h,cellWidth, cellHeight);
        }
     
        NSValue *cellFrameValue = [NSValue valueWithCGRect:cellFrame];

        [self.cellFrames addObject:cellFrameValue];

        if (i == (cellCount - 1)) {
            self.contentSize = CGSizeMake(self.frame.size.width,  CGRectGetMaxY(cellFrame));
        }
        
    }
    
}

//根据标识符去缓存池中去cell
-(HoneycombCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
  __block  HoneycombCell *reusableCell = nil;
    
    [self.reuseableCells enumerateObjectsUsingBlock:^(HoneycombCell *cell, BOOL * _Nonnull stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell = cell;
            *stop = YES;
        }
        
    }];
    
    if (reusableCell != nil) {
        [self.reuseableCells removeObject:reusableCell];
    }
    
    return reusableCell;
}


#pragma mark- 内部私有方法
-(CGFloat)cellWidehWithColumMargin:(CGFloat)columnMargin columnCount:(NSUInteger)columnCount{
    
    CGFloat cellWidth = (self.bounds.size.width - columnCount * columnMargin) / columnCount;
    return cellWidth;
}

//列间距
-(CGFloat)columnMargin{
    CGFloat cMargin = defaultColumnMargin;
    if ([self.delegate respondsToSelector:@selector(honeycombView:marginForType:)]) {
        cMargin = [self.delegate honeycombView:self marginForType:honeycombViewMaginType_column];
    }
    return cMargin;
}

//行间距
-(CGFloat)rowMargin{
    CGFloat rMargin = defaultColumnMargin;
    if ([self.delegate respondsToSelector:@selector(honeycombView:marginForType:)]) {
        rMargin = [self.delegate honeycombView:self marginForType:honeycombViewMaginType_row];
    }
    return rMargin;
}

//列数
-(NSUInteger)columnCount{
    NSUInteger columnCount = defaultColumnCount;
    if ([self.dataSource respondsToSelector:@selector(columnsInHoneycombView:)]) {
        columnCount = [self.dataSource columnsInHoneycombView:self];
    }
    return columnCount;
}

//判断 frame 是否在屏幕上
-(BOOL)isFrameInScreen:(CGRect)frame{
    CGFloat maxY = CGRectGetMaxY(frame);
    CGFloat minY = CGRectGetMinY(frame);
    return (maxY > self.contentOffset.y && minY < (self.contentOffset.y + self.frame.size.height));
}

#pragma mark- 事件处理

-(void)tapGestureTapAction:(UITapGestureRecognizer *)tapGesture{
    if (tapGesture.state == UIGestureRecognizerStateRecognized) {
        
//        NSLog(@"tap");
        CGPoint point = [tapGesture locationInView:self];
        
        __block NSNumber *indexNum = nil;
        [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(NSNumber *indexNumber, HoneycombCell *cell, BOOL * _Nonnull stop) {
            
            if (CGRectContainsPoint(cell.frame, point)) {
                indexNum = indexNumber;
                *stop = YES;
            }
        }];
        if (indexNum != nil) {
            if ([self.delegate respondsToSelector:@selector(honeycombView:didSelectCellAtIndex:)]) {
                [self.delegate honeycombView:self didSelectCellAtIndex:[indexNum integerValue]];
            }
        }
    }
}
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//
//    __block NSNumber *indexNum = nil;
//    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(NSNumber *indexNumber, HoneycombCell *cell, BOOL * _Nonnull stop) {
//        
//        if (CGRectContainsPoint(cell.frame, point)) {
//            indexNum = indexNumber;
//            *stop = YES;
//        }
//    }];
//    if (indexNum != nil) {
//        if ([self.delegate respondsToSelector:@selector(honeycombView:didSelectCellAtIndex:)]) {
//            [self.delegate honeycombView:self didSelectCellAtIndex:[indexNum integerValue]];
//        }
//    }
//   
//  
//}






@end
