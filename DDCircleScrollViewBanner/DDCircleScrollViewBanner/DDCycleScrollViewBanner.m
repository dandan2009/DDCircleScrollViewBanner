//
//  DDPageIndicatorView.m
//
//
//  Created by shan on 2018/10/31.
//  Copyright © 2018年 shan. All rights reserved.
//  

#import "DDCycleScrollViewBanner.h"
#import "DDPageIndicatorView.h"
#import "UIView+Additions.h"

#define ScrollItemViewTag 1096700

@interface DDCycleScrollViewBanner (){
    UIScrollView   *contentScrollView;
    NSTimer        *scrollTimer;
    NSArray        *dataArray;
    NSMutableArray *scrollDataArray;
}
@property(nonatomic, strong) DDPageIndicatorView *pageControlView;//分页圆点控件
@property(nonatomic, strong) NSString *scrollDirect;//滚动方向
@end

@implementation DDCycleScrollViewBanner
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate isShowPageIndicator:(BOOL)isShowPageIndicator{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
        
        contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        contentScrollView.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.delegate = self;
        contentScrollView.pagingEnabled = YES;
        [self addSubview:contentScrollView];
        
        self.delegate = delegate;
        
        if (isShowPageIndicator) {
            [self addSubview:self.pageControlView];
        }
        scrollDataArray = [NSMutableArray array];
        self.currentIndex = 0;
    }
    return self;
}


- (void)setDataWithArray:(NSArray *)data {
    dataArray = data;
     self.currentIndex = self.currentIndex % dataArray.count;
    if ([dataArray count] > 1) {
        self.pageControlView.hidden = NO;
        contentScrollView.scrollEnabled = YES;
        [self.pageControlView updateViewWithCount:(int)[dataArray count]];
        [self.pageControlView setSelectedImageIndex:0];
        if (!scrollTimer) {
            self.scrollDirect = @"middle";
            [self refreshScrollView];
            [self startTimer];
        }
        
    }
    else {
        self.pageControlView.hidden = YES;
        contentScrollView.scrollEnabled = NO;
        [self invalidTimer];
        self.scrollDirect = @"middle";
        [self refreshScrollView];
    }
}


- (DDPageIndicatorView *)pageControlView {
    if (!_pageControlView) {
        _pageControlView = [[DDPageIndicatorView alloc] initWithFrame:CGRectMake(0, self.height - KConvertTo375(6), self.width, KConvertTo375(3)) imageWidth:KConvertTo375(7) spaceWidth:KConvertTo375(2) totalCount:1 normalColor:nil highlightedColor:nil];
//        _pageControlView.backgroundColor = [UIColor redColor];
//        [_pageControlView setNeedCornerRadius:NO];
        [self addSubview:_pageControlView];
    }
    return _pageControlView;
}

- (void)refreshScrollView {
    //scroll只加载3个itemView
    [scrollDataArray removeAllObjects];
    [scrollDataArray addObject:[dataArray objectAtIndex:[self getPrePage]]];
    [scrollDataArray addObject:[dataArray objectAtIndex:self.currentIndex]];
    [scrollDataArray addObject:[dataArray objectAtIndex:[self getNextPage]]];
    
    contentScrollView.contentSize = CGSizeMake(contentScrollView.width*[scrollDataArray count], 0);
    for (int i = 0; i < [scrollDataArray count]; i++) {
        UIView *itemView = [contentScrollView viewWithTag:ScrollItemViewTag+i];
        
        if (!itemView) {
            
            if (![self.delegate respondsToSelector:@selector(getScrollViewItemWithFrame:)] || ![self.delegate respondsToSelector:@selector(setScrollViewItem:withModule:)]) {
                return;
            }
            
            itemView = [self.delegate getScrollViewItemWithFrame:CGRectMake(contentScrollView.width *i, 0, contentScrollView.width, contentScrollView.height)];
            //为了使用tag属性
            UIView *contentView = [UIView new];
            contentView.frame = itemView.frame;
            itemView.frame = itemView.bounds;
            [contentView addSubview:itemView];
            
            contentView.tag = ScrollItemViewTag+i;
            [contentScrollView addSubview:contentView];
            id dto = [scrollDataArray objectAtIndex:i];
            [self.delegate setScrollViewItem:itemView withModule:dto];
        }
        else{
            if ([self.scrollDirect isEqualToString:@"middle"]) {//下拉刷新
                id dto = [scrollDataArray objectAtIndex:i];
                [self.delegate setScrollViewItem:itemView withModule:dto];
            }
            else if ([self.scrollDirect isEqualToString:@"right"]) {//右滑
                UIView *itemView2 = [contentScrollView viewWithTag:ScrollItemViewTag+2];
                id dto = [scrollDataArray objectAtIndex:0];
                [self.delegate setScrollViewItem:itemView2 withModule:dto];
                itemView2.frame = CGRectMake(contentScrollView.width *0, 0, contentScrollView.width, contentScrollView.height);
                
                UIView *itemView0 = [contentScrollView viewWithTag:ScrollItemViewTag+0];
                itemView0.frame = CGRectMake(contentScrollView.width *1, 0, contentScrollView.width, contentScrollView.height);
                
                UIView *itemView1 = [contentScrollView viewWithTag:ScrollItemViewTag+1];
                itemView1.frame = CGRectMake(contentScrollView.width *2, 0, contentScrollView.width, contentScrollView.height);
                
                itemView0.tag = ScrollItemViewTag+1;
                itemView1.tag = ScrollItemViewTag+2;
                itemView2.tag = ScrollItemViewTag+0;
            }
            else{//左滑
                UIView *itemView0 = [contentScrollView viewWithTag:ScrollItemViewTag+0];
                id dto = [scrollDataArray objectAtIndex:2];
                [self.delegate setScrollViewItem:itemView0 withModule:dto];
                itemView0.frame = CGRectMake(contentScrollView.width *2, 0, contentScrollView.width, contentScrollView.height);
                
                UIView *itemView1 = [contentScrollView viewWithTag:ScrollItemViewTag+1];
                itemView1.frame = CGRectMake(contentScrollView.width *0, 0, contentScrollView.width, contentScrollView.height);
                
                UIView *itemView2 = [contentScrollView viewWithTag:ScrollItemViewTag+2];
                itemView2.frame = CGRectMake(contentScrollView.width *1, 0, contentScrollView.width, contentScrollView.height);
                
                itemView1.tag = ScrollItemViewTag+0;
                itemView2.tag = ScrollItemViewTag+1;
                itemView0.tag = ScrollItemViewTag+2;
            }
            break;
        }
    }
    [contentScrollView setContentOffset:CGPointMake(contentScrollView.width, 0)];
    [self.pageControlView setSelectedImageIndex:self.currentIndex];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat xOffset = scrollView.contentOffset.x;
    if (((int)xOffset % (int)scrollView.frame.size.width == 0)) {
        [self.pageControlView setSelectedImageIndex:self.currentIndex];
    }
    
    if(xOffset >= (2*(int)scrollView.frame.size.width)) {
        self.scrollDirect = @"left";
        //向左滑
        self.currentIndex++;
        self.currentIndex = self.currentIndex % [dataArray count];
        [self refreshScrollView];
        return;
    }
    if(xOffset <= 0) {
        self.scrollDirect = @"right";
        //向右滑
        if (self.currentIndex == 0) {
            self.currentIndex = [dataArray count] - 1;
        }
        else {
            self.currentIndex--;
        }
        [self refreshScrollView];
    }
}

//拖动开始，停止计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self invalidTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView{
    [contentScrollView setContentOffset:CGPointMake(contentScrollView.width, 0)];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //开启定时器
    if ([dataArray count] > 1) {
        [self startTimer];
    }
}

/**
 *  开启计时器
 */
- (void)startTimer {
    if (scrollTimer) {
        [self invalidTimer];
    }
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:scrollTimer forMode:NSRunLoopCommonModes];
}

/**
 *  停止计时器
 */
- (void)invalidTimer {
    [scrollTimer invalidate];
    scrollTimer = nil;
}

/**
 *  获取上一页页号
 *
 *  @return 上一页页号
 */
- (NSUInteger )getPrePage {
    NSUInteger result = 0;
    if (self.currentIndex == 0) {
        result = [dataArray count] - 1;
    }
    else {
        result = self.currentIndex - 1;
    }
    return result;
}

/**
 *  获取下一页页号
 *
 *  @return 下一页页号
 */
- (NSUInteger )getNextPage {
    NSUInteger result = 0;
    if ((self.currentIndex+1) >= [dataArray count]) {
        result = 0;
    }
    else {
        result = self.currentIndex + 1;
    }
    return result;
}

/**
 *  切换图片
 */
- (void)changeImage {
    self.scrollDirect = @"left";
    self.currentIndex++;
    self.currentIndex = self.currentIndex % [dataArray count];
    //添加动画
    for (int i = 0; i < 3; i++) {
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.35f];
        [animation setFillMode:kCAFillModeForwards];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        
        UIView *itemView = [contentScrollView viewWithTag:ScrollItemViewTag+i];
        [itemView.layer addAnimation:animation forKey:nil];
    }
    
    [self.pageControlView setSelectedImageIndex:self.currentIndex];
    [self refreshScrollView];
}

@end
