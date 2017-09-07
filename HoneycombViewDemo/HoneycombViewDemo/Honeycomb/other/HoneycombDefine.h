//
//  HoneycombDefine.h
//  HoneycombViewDemo
//
//  Created by 杨 on 17/2/5.
//  Copyright © 2017年 杨. All rights reserved.
//

#ifndef HoneycombDefine_h
#define HoneycombDefine_h
#ifdef __OBJC__

#define HoneycombColorRGBA(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define HoneycombColor(r,g,b)        HoneycombColorRGBA(r,g,b,255.0)
#define HoneycombRandomColor         HoneycombColor((arc4random_uniform(255)),(arc4random_uniform(255)),(arc4random_uniform(255)))


#endif /* __OBJC__ */
#endif /* HoneycombDefine_h */
