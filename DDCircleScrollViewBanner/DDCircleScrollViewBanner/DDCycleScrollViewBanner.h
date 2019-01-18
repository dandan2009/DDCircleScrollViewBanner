//
//  DDPageIndicatorView.h
//
//
//  Created by shan on 2018/10/31.
//  Copyright © 2018年 shan. All rights reserved.
//  使用示例在下方

#import "DDPageIndicatorView.h"

#pragma mark - DDCycleScrollViewBannerDelegate
@protocol DDCycleScrollViewBannerDelegate<NSObject>
@required
/**
 获取滚动的item

 @param frame item的frame
 @return 滚动的item 
 */
- (UIView *)getScrollViewItemWithFrame:(CGRect)frame;

/**
 给item设置值

 @param item 滚动item
 @param module item对应的数据
 */
- (void)setScrollViewItem:(UIView *)item withModule:(id)module;
@end



#pragma mark - DDCycleScrollViewBanner
@interface DDCycleScrollViewBanner : UIView <UIScrollViewDelegate>

@property(nonatomic,assign)    NSUInteger currentIndex;//当前正在显示的数据的下标
@property(nullable,nonatomic,weak) id<DDCycleScrollViewBannerDelegate>  delegate;

/**
 务必使用此方法进行初始化

 @param frame ScrollView的frame
 @param delegate delegate
 @param isShowPageIndicator 是否显示页面指示器
 @return DDCycleScrollViewBanner 对象
 */
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate isShowPageIndicator:(BOOL)isShowPageIndicator;

- (void)setDataWithArray:(NSArray *)data;


@end


#pragma mark - 使用示例

/*
- (void)viewDidLoad {
    DDCycleScrollViewBanner *banner = [[DDCycleScrollViewBanner alloc] initWithFrame:CGRectMake(0, 300, kScreenWidth-20, 200) delegate:self isShowPageIndicator:YES];
    
    
    NSArray *data = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    //需要你提供数据源
    [banner setDataWithArray:data];
    banner.tag = 100;
    [self.view addSubview:banner];
}

//获取滚动的item，需要你自己实现
- (UIView *)getScrollViewItemWithFrame:(CGRect)frame{
    UIControl *view = [[UIControl alloc] initWithFrame:frame];
    UILabel *lab =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    lab.backgroundColor = [UIColor yellowColor];
    lab.tag = 1000;
    view.backgroundColor = [UIColor purpleColor];
    [view addSubview:lab];
    [view addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

// item的点击事件
- (void)action{
    DDCycleScrollViewBanner *banner = [self.view viewWithTag:100];
    NSLog(@"banner.currentIndex : %ld",banner.currentIndex);
}

// 给滚动的item设值
- (void)setScrollViewItem:(UIControl *)item withModule:(id)module{
    UILabel *lab = [item viewWithTag:1000];
    lab.text = module;
}
 */
