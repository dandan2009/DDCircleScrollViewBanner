//
//  DDPageIndicatorView.h
//  
//
//  Created by shan on 2018/10/31.
//  Copyright © 2018年 shan. All rights reserved.
//  使用示例在下方

#import <UIKit/UIKit.h>
#import "DDCycleScrollView.h"

@interface DDPageIndicatorView : UIView 

/**
 初始化分页指示器

 @param frame 分页指示器的frame
 @param imgWidth 分页指示器 圆点的宽度，高度等于self的高度
 @param spaceWidth 圆点之间的间隔
 @param count 圆点的总数
 @return 分页指示器
 */
- (DDPageIndicatorView *)initWithFrame:(CGRect)frame imageWidth:(int )imgWidth spaceWidth:(int )spaceWidth totalCount:(int )count;


/**
 初始化分页指示器

 @param frame 分页指示器的frame
 @param imgWidth 分页指示器的frame
 @param spaceWidth 圆点之间的间隔
 @param count 圆点之间的间隔
 @param normalColor 圆点的默认颜色
 @param highlightedColor 圆点的高亮颜色
 @return 分页指示器
 */
- (DDPageIndicatorView *)initWithFrame:(CGRect)frame imageWidth:(int )imgWidth spaceWidth:(int )spaceWidth totalCount:(int )count normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor;


/**
 设置圆点的默认色和选中颜色

 @param normalColor 圆点的默认色
 @param highlightedColor 圆点的高亮色
 */
-(void)setNormalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor;


/**
 更新圆点总数

 @param count 圆点总数
 */
- (void)updateViewWithCount:(int )count;



/**
 选中某一页

 @param index 页码
 */
- (void)setSelectedImageIndex:(NSUInteger )index;


@end

#pragma mark - 使用示例

/*
 //初始化
 self.pageControlView = [[DDPageIndicatorView alloc] initWithFrame:CGRectMake(0, self.height - Get375Width(6), self.width, Get375Width(3)) imageWidth:Get375Width(8) spaceWidth:Get375Width(2) totalCount:1 normalColor:nil highlightedColor:nil];
 [self addSubview:self.pageControlView];
 
 //设置总数
 [self.pageControlView updateViewWithCount:(int)[dataArray count]];
 
 
 //选中某一页
 [self.pageControlView setSelectedImageIndex:0];
 */
