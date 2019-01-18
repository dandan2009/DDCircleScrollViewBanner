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
   
    DDCycleScrollViewBanner *banner = [[DDCycleScrollViewBanner alloc] initWithFrame:CGRectMake(0, 300, kScreenWidth-20, 200) delegate:self isShowPageIndicator:YES];
    
    
    NSArray *data = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    //需要你提供数据源
    [banner setDataWithArray:data];
    banner.tag = 100;
    [self.view addSubview:banner];
}


#pragma mark - 使用示例


 
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

@end
