//
//  HoneycombCell.m
//  HoneycombViewDemo
//
//  Created by 杨 on 17/2/5.
//  Copyright © 2017年 杨. All rights reserved.
//

#import "HoneycombCell.h"

@implementation HoneycombCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        self.imgV = [self addImageView];
        self.titleLb = [self addLabel];
       
        //[self setupBorder];
        
         self.layer.borderColor = HoneycombRandomColor.CGColor;
    }
    return self;
}


-(UIImageView *)addImageView{
    UIImageView *imgV = [[UIImageView alloc]init];
    [self addSubview:imgV];
    return imgV;
}

-(UILabel *)addLabel{
    UILabel *lb = [[UILabel alloc]init];
    lb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lb];
    return lb;
  
}

-(void)setupBorder{
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 0.5;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame = self.bounds;
    self.imgV.frame = self.bounds;
}
@end
