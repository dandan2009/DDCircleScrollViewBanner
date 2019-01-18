//
//  ViewController.m
//  DDCircleScrollViewBanner
//
//  Created by shan on 2019/1/17.
//  Copyright © 2019 shan. All rights reserved.
//

#import "ViewController.h"
#import "DDCycleScrollViewBanner.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    DDCycleScrollViewBanner *banner = [[DDCycleScrollViewBanner alloc] initWithFrame:CGRectMake(10, 100, kScreenWidth-20, 200) delegate:self isShowPageIndicator:YES];
    
    //相当于你的数据源
    NSArray *data = @[@"001.jpg",@"002.jpg",@"003.jpg",@"004.jpg",@"005.jpg"];
    //需要你提供数据源
    [banner setDataWithArray:data];
    [self.view addSubview:banner];
}


#pragma mark - 使用示例


 
 //获取滚动的item，需要你自己实现
 - (UIView *)getScrollViewItemWithFrame:(CGRect)frame{
 UIControl *view = [[UIControl alloc] initWithFrame:frame];
 UIImageView *imageView =[[UIImageView alloc] initWithFrame:view.bounds];
 imageView.tag = 1000;
 [view addSubview:imageView];
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
 UIImageView *imageView = [item viewWithTag:1000];
     imageView.image = [UIImage imageNamed:module];
 }

@end
