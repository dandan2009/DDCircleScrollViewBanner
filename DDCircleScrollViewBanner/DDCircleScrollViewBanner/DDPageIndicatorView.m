//
//  DDPageIndicatorView
//
//
//  Created by shan on 2018/10/31.
//  Copyright © 2018年 shan. All rights reserved.
//


#define KImageSpaceWidth  5

#import "DDPageIndicatorView.h"

@interface DDPageIndicatorView () {
    //分段的总数
    int    totalCount;
    //普通状态时的图片
    UIImage    *normalImage;
    
    //高亮状态时的图片
    UIImage    *hilightedImage;
    
    //当前已经显示的高亮图片的index
    NSUInteger currentSelectedIndex;
    
    //每个图片是否需要显示圆角
    BOOL imageNeedCornerRadius;
}

@property (nonatomic, assign) int imageWidth;

@property (nonatomic, assign) int whiteSpaceWidth;
@end

@implementation DDPageIndicatorView

- (id)initWithFrame:(CGRect)frame imageWidth:(int )imgWidth spaceWidth:(int )spaceWidth totalCount:(int )count{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //初始化时设置总数、图片宽度、空白宽度
        totalCount = count;
        _imageWidth = imgWidth;
        _whiteSpaceWidth = spaceWidth;
        imageNeedCornerRadius = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (DDPageIndicatorView *)initWithFrame:(CGRect)frame imageWidth:(int )imgWidth spaceWidth:(int )spaceWidth totalCount:(int )count normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor{
    self = [self initWithFrame:frame imageWidth:imgWidth spaceWidth:spaceWidth totalCount:count];
    if (self) {
        [self setNormalColor:normalColor highlightedColor:highlightedColor];
    }
    return self;
}

-(void)setNormalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor{
    UIView *normalViewContent = [[UIView alloc] initWithFrame:CGRectMake(0.5, 0, _imageWidth-1, self.frame.size.height)];
    if (!normalColor) {
        normalColor = TCUIColorFromRGB(0xCCCCCC);
    }
    normalViewContent.backgroundColor = normalColor;
    normalViewContent.layer.cornerRadius = 1;
    normalViewContent.clipsToBounds      = YES;
    
    UIView *normalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _imageWidth, self.frame.size.height)];
    [normalView addSubview:normalViewContent];
    normalImage = [self convertViewToImage:normalView];
    
    UIView *highlightedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _imageWidth, self.frame.size.height)];
    if (!highlightedColor) {
        highlightedColor = TCUIColorFromRGB(0xFFAA00);
    }
    highlightedView.backgroundColor = highlightedColor;
    highlightedView.layer.cornerRadius = 1;
    highlightedView.clipsToBounds      = YES;
    
    hilightedImage = [self convertViewToImage:highlightedView];
}



/**
 *  更新view
 *
 *  @param count count
 */
- (void)updateViewWithCount:(int )count {
    //设置新的UI元素
    totalCount = count;
    //内部重新加载
    [self refreshAllSubView];
}

/**
 *  刷新view
 */
- (void)refreshAllSubView {
    //移除旧的视图内容
    NSArray *viewArray = [self subviews];
    [viewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int totalWidth = (totalCount -1)*(_imageWidth+_whiteSpaceWidth) + _imageWidth;
    
    //设置新的内容
    for (int i = 0; i < totalCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_imageWidth + _whiteSpaceWidth) * i + self.frame.size.width/2.0 - totalWidth/2.0, 0, _imageWidth, self.frame.size.height)];
        
        imageView.tag = 10000+i;
        if (i == 0) {
            imageView.image = hilightedImage;
            currentSelectedIndex = 0;
        }
        else {
            imageView.image = normalImage;
        }
        [self addSubview:imageView];
    }
}

/**
 *  设置选中index
 *
 *  @param index index
 */
- (void)setSelectedImageIndex:(NSUInteger )index {
    
    UIImageView *oldIamgeView = (UIImageView *)[self viewWithTag:10000+currentSelectedIndex];
    UIImageView *newImageView = (UIImageView *)[self viewWithTag:10000+index];
    if (oldIamgeView) {
        oldIamgeView.image = normalImage;
    }

    if (newImageView) {
        newImageView.image = hilightedImage;
    }
    currentSelectedIndex = index;
}


/**
 *  设置每个图片是否需要显示圆角
 */
- (void)setNeedCornerRadius:(BOOL)flag {
    imageNeedCornerRadius = flag;
}


-(UIImage*)convertViewToImage:(UIView*)view{
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
