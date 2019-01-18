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
    UIScrollView   *imageScroll;
    NSTimer        *scrollTimer;
    NSArray *dataArray;
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
        
        imageScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        imageScroll.backgroundColor = TCUIColorFromRGB(0xf2f2f2);
        imageScroll.showsHorizontalScrollIndicator = NO;
        imageScroll.delegate = self;
        imageScroll.pagingEnabled = YES;
        [self addSubview:imageScroll];
        
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
        imageScroll.scrollEnabled = YES;
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
        imageScroll.scrollEnabled = NO;
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
    //scroll只加载3个图片
    //配置当前需要显示的3个DTO,
    [scrollDataArray removeAllObjects];
    [scrollDataArray addObject:[dataArray objectAtIndex:[self getPrePage]]];
    [scrollDataArray addObject:[dataArray objectAtIndex:self.currentIndex]];
    [scrollDataArray addObject:[dataArray objectAtIndex:[self getNextPage]]];
    
    imageScroll.contentSize = CGSizeMake(imageScroll.width*[scrollDataArray count], 0);
    for (int i = 0; i < [scrollDataArray count]; i++) {
        UIView *imageView = [imageScroll viewWithTag:ScrollItemViewTag+i];
        
        if (!imageView) {
            
            if (![self.delegate respondsToSelector:@selector(getScrollViewItemWithFrame:)] || ![self.delegate respondsToSelector:@selector(setScrollViewItem:withModule:)]) {
                return;
            }
            
            imageView = [self.delegate getScrollViewItemWithFrame:CGRectMake(imageScroll.width *i, 0, imageScroll.width, imageScroll.height)];
            //为了使用tag属性
            UIView *contentView = [UIView new];
            contentView.frame = imageView.frame;
            imageView.frame = imageView.bounds;
            [contentView addSubview:imageView];
            
            contentView.tag = ScrollItemViewTag+i;
            [imageScroll addSubview:contentView];
            id dto = [scrollDataArray objectAtIndex:i];
            [self.delegate setScrollViewItem:imageView withModule:dto];
        }
        else{
            if ([self.scrollDirect isEqualToString:@"middle"]) {//下拉刷新
                id dto = [scrollDataArray objectAtIndex:i];
                [self.delegate setScrollViewItem:imageView withModule:dto];
            }
            else if ([self.scrollDirect isEqualToString:@"right"]) {//右滑
                UIView *imageView2 = [imageScroll viewWithTag:ScrollItemViewTag+2];
                id dto = [scrollDataArray objectAtIndex:0];
                [self.delegate setScrollViewItem:imageView2 withModule:dto];
                imageView2.frame = CGRectMake(imageScroll.width *0, 0, imageScroll.width, imageScroll.height);
                
                UIView *imageView0 = [imageScroll viewWithTag:ScrollItemViewTag+0];
                imageView0.frame = CGRectMake(imageScroll.width *1, 0, imageScroll.width, imageScroll.height);
                
                UIView *imageView1 = [imageScroll viewWithTag:ScrollItemViewTag+1];
                imageView1.frame = CGRectMake(imageScroll.width *2, 0, imageScroll.width, imageScroll.height);
                
                imageView0.tag = ScrollItemViewTag+1;
                imageView1.tag = ScrollItemViewTag+2;
                imageView2.tag = ScrollItemViewTag+0;
            }
            else{//左滑
                UIView *imageView0 = [imageScroll viewWithTag:ScrollItemViewTag+0];
                id dto = [scrollDataArray objectAtIndex:2];
                [self.delegate setScrollViewItem:imageView0 withModule:dto];
                imageView0.frame = CGRectMake(imageScroll.width *2, 0, imageScroll.width, imageScroll.height);
                
                UIView *imageView1 = [imageScroll viewWithTag:ScrollItemViewTag+1];
                imageView1.frame = CGRectMake(imageScroll.width *0, 0, imageScroll.width, imageScroll.height);
                
                UIView *imageView2 = [imageScroll viewWithTag:ScrollItemViewTag+2];
                imageView2.frame = CGRectMake(imageScroll.width *1, 0, imageScroll.width, imageScroll.height);
                
                imageView1.tag = ScrollItemViewTag+0;
                imageView2.tag = ScrollItemViewTag+1;
                imageView0.tag = ScrollItemViewTag+2;
            }
            break;
        }
    }
    [imageScroll setContentOffset:CGPointMake(imageScroll.width, 0)];
    [self.pageControlView setSelectedImageIndex:self.currentIndex];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat xOffset = scrollView.contentOffset.x;
    if (((int)xOffset % (int)scrollView.frame.size.width == 0)) {
        [self.pageControlView setSelectedImageIndex:self.currentIndex];
    }
    
    // 水平滚动
    // 往下翻一张
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
    [imageScroll setContentOffset:CGPointMake(imageScroll.width, 0)];
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
    for (int i = 0; i < 3; i++) {
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.35f];
        [animation setFillMode:kCAFillModeForwards];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        
        UIView *imageView = [imageScroll viewWithTag:ScrollItemViewTag+i];
        [imageView.layer addAnimation:animation forKey:nil];
    }
    
    [self.pageControlView setSelectedImageIndex:self.currentIndex];
    [self refreshScrollView];
}

@end
