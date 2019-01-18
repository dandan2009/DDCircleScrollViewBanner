//
//  DDCycleScrollView.h
//
//
//  Created by shan on 2018/10/31.
//  Copyright © 2018年 shan. All rights reserved.
//


#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KConvertTo375(w)   (w) * kScreenWidth / 375.0f
#define TCUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) &0xFF00) >>8))/255.0 blue:((float)((rgbValue) &0xFF))/255.0 alpha:1.0]

