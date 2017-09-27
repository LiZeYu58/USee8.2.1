//
//  MJRefreshBaseView.m
//  MJRefresh
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJRefreshBaseView.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"
#import <objc/message.h>

@interface  MJRefreshBaseView()
{
    __weak UILabel *_statusLabel;
    __weak UIImageView *_arrowImage;
    __weak UIActivityIndicatorView *_activityView;
    __weak UIImageView *_gifImage;
    BOOL _endingRefresh;
}
@end

@implementation MJRefreshBaseView
#pragma mark - 控件初始化
/**
 *  状态标签
 */
- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusLabel.font = [UIFont boldSystemFontOfSize:13];
        statusLabel.textColor = MJRefreshLabelTextColor;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel = statusLabel];
    }
    return _statusLabel;
}

/**
 *  箭头图片
 */
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_下拉上拉_正在刷新11"]];
        arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_arrowImage = arrowImage];
    }
    return _arrowImage;
}

/**
 *  状态标签
 */
- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds = self.arrowImage.bounds;
        activityView.autoresizingMask = self.arrowImage.autoresizingMask;
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}
/**
 *  状态gif动画
 */
-(UIImageView *)gifImage{
    if (!_gifImage) {
        UIImageView *gifImage = [[UIImageView alloc] init];
        gifImage.bounds = CGRectMake(0, 0, 30, 40);
        gifImage.autoresizingMask = self.arrowImage.autoresizingMask;
        NSArray *gifArray = [NSArray arrayWithObjects:
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新01"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新02"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新03"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新04"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新05"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新06"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新07"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新08"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新09"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新10"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新11"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新12"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新13"],
                             [UIImage imageNamed:@"img_下拉上拉_正在刷新14"],
                             nil];
        gifImage.animationImages = gifArray; //动画图片数组
        gifImage.animationDuration = gifImage.animationImages.count * 0.08; //执行一次完整动画所需的时长
        gifImage.animationRepeatCount = 500;  //动画重复次数
        [self addSubview:_gifImage = gifImage];
    }
    return _gifImage;
}
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = MJRefreshViewHeight;
    if (self = [super initWithFrame:frame]) {
        // 1.自己的属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        // 2.设置默认状态
        self.state = MJRefreshStateNormal;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.箭头
     CGFloat arrowX;
    if (self.mj_width > SCREEN_WIDTH + 10) {
        arrowX = self.mj_width * 0.5 - 120;
    }
    else{
        arrowX = self.mj_width * 0.5 - 75;
    }
    
       
    self.arrowImage.center = CGPointMake(arrowX, self.mj_height * 0.5);
    
    // 2.指示器
   // self.activityView.center = self.arrowImage.center;
    self.gifImage.center = self.arrowImage.center;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:MJRefreshContentOffset context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:MJRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        // 设置宽度
        self.mj_width = newSuperview.mj_width;
        // 设置位置
        self.mj_x = 0;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

#pragma mark - 显示到屏幕上
- (void)drawRect:(CGRect)rect
{
    if (self.state == MJRefreshStateWillRefreshing) {
        self.state = MJRefreshStateRefreshing;
    }
}

#pragma mark - 刷新相关
#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return MJRefreshStateRefreshing == self.state;
}

#pragma mark 开始刷新
- (void)beginRefreshing
{
    if (self.state == MJRefreshStateRefreshing) {
        // 回调
        if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
            msgSend(msgTarget(self.beginRefreshingTaget), self.beginRefreshingAction, self);
        }
        
        if (self.beginRefreshingCallback) {
            self.beginRefreshingCallback();
        }
    } else {
        if (self.window) {
            self.state = MJRefreshStateRefreshing;
        } else {
    #warning 不能调用set方法
            _state = MJRefreshStateWillRefreshing;
            
#warning 为了保证在viewWillAppear等方法中也能刷新
            [self setNeedsDisplay];
        }
    }
}

#pragma mark 结束刷新
- (void)endRefreshing
{
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.state = MJRefreshStateNormal;
    });
}

#pragma mark - 设置状态
- (void)setPullToRefreshText:(NSString *)pullToRefreshText
{
    _pullToRefreshText = [pullToRefreshText copy];
    [self settingLabelText];
}
- (void)setReleaseToRefreshText:(NSString *)releaseToRefreshText
{
    _releaseToRefreshText = [releaseToRefreshText copy];
    [self settingLabelText];
}
- (void)setRefreshingText:(NSString *)refreshingText
{
    _refreshingText = [refreshingText copy];
    [self settingLabelText];
}
- (void)settingLabelText
{
	switch (self.state) {
		case MJRefreshStateNormal:
            // 设置文字
            self.statusLabel.text = self.pullToRefreshText;
			break;
		case MJRefreshStatePulling:
            // 设置文字
            self.statusLabel.text = self.releaseToRefreshText;
			break;
        case MJRefreshStateRefreshing:
            // 设置文字
            self.statusLabel.text = self.refreshingText;
			break;
        default:
            break;
	}
}

- (void)setState:(MJRefreshState)state
{
    // 0.存储当前的contentInset
    if (self.state != MJRefreshStateRefreshing) {
        _scrollViewOriginalInset = self.scrollView.contentInset;
    }
    
    // 1.一样的就直接返回(暂时不返回)
    if (self.state == state) return;
    
    // 2.旧状态
    MJRefreshState oldState = self.state;
    
    // 3.存储状态
    _state = state;
    
    // 4.根据状态执行不同的操作
    switch (state) {
		case MJRefreshStateNormal: // 普通状态
        {
            if (oldState == MJRefreshStateRefreshing) {
                // 正在结束刷新
                _endingRefresh = YES;
                
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration * 0.6 animations:^{
                    self.activityView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    // 停止转圈圈
                    //[self.activityView stopAnimating];
                    [self.gifImage startAnimating];
                    // 恢复alpha
                    self.activityView.alpha = 1.0;
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJRefreshSlowAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 等头部回去
                    // 显示箭头
                    self.arrowImage.hidden = NO;
                    
                    // 停止转圈圈
                    //[self.activityView stopAnimating];
                    [self.gifImage stopAnimating];
                    // 设置文字
                    [self settingLabelText];
                    
                    // 结束刷新完毕
                    _endingRefresh = NO;
                });
                // 直接返回
                return;
            } else {
                // 显示箭头
                self.arrowImage.hidden = NO;
                
                // 停止转圈圈
                //[self.activityView stopAnimating];
                [self.gifImage stopAnimating];
            }
			break;
        }
            
        case MJRefreshStatePulling:
            break;
            
		case MJRefreshStateRefreshing:
        {
            // 开始转圈圈
			//[self.activityView startAnimating];
            [self.gifImage startAnimating];
            // 隐藏箭头
			self.arrowImage.hidden = YES;
            
            // 回调
            if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
                msgSend(msgTarget(self.beginRefreshingTaget), self.beginRefreshingAction, self);
            }
            
            if (self.beginRefreshingCallback) {
                self.beginRefreshingCallback();
            }
			break;
        }
        default:
            break;
	}
    
    // 5.设置文字
    [self settingLabelText];
}
@end
