//
//  HoneycombCell.h
//  HoneycombViewDemo
//
//  Created by 杨 on 17/2/5.
//  Copyright © 2017年 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HoneycombDefine.h"

@interface HoneycombCell : UIView

@property(nonatomic,weak)UILabel *titleLb;
@property(nonatomic,weak)UIImageView *imgV;


@property(nonatomic, copy)NSString *identifier;



@end
