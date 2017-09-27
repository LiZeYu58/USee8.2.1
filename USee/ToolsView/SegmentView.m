//
//  SegmentView.m
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



    //排行与收藏夹的切换



#import "SegmentView.h"
#import "AppDelegate.h"

@interface SegmentView ()
{
    UIView *_linView;
    CGRect _fram;
}

@end


@implementation SegmentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _fram = frame;
     
    }
    return self;
}


- (void)loadTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    [self loadMobileLinView];
}

- (void)loadMobileLinView{
    
    //  排行和收藏夹 上方的阴影
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.width, 2) cornerRadius:1];
    self.layer.shadowPath = path.CGPath;
    [[self layer] setShadowOffset:CGSizeMake(0, 0)];
    [[self layer] setShadowOpacity:0.9];
    [[self layer] setShadowColor:[UIColor blackColor].CGColor];
    
  
    
    if (!_textSeletedColor) {
        _textSeletedColor = _textNormalColor;
    }
    
    
    _linView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _fram.size.width/_titleArray.count, 3)];
    _linView.backgroundColor = _linColor;
    [self addSubview:_linView];
    
    
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i*(_fram.size.width/_titleArray.count), 0, _fram.size.width/_titleArray.count, _fram.size.height-3);
        button.tag = 10 + i;
        button.titleLabel.font = _textFont;
        i == 0?([button setTitleColor:_textSeletedColor forState:UIControlStateNormal]):([button setTitleColor:_textNormalColor forState:UIControlStateNormal]);
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];        
        [self addSubview:button];
    }
}

- (void)buttonPressed:(UIButton *)sender{
    
    DLog(@"ddddddddddddddddddddddddd");
    
    NSInteger userType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] integerValue];
    
    if (userType == 2) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"收费用户可用" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _linView.frame = CGRectMake(sender.frame.origin.x, _linView.frame.origin.y, _linView.frame.size.width, 3);
            
        } completion:nil];
        
        for (int i = 0; i<_titleArray.count; i++) {
            UIButton *button = (UIButton *)[self viewWithTag:i + 10];
            sender.tag == (i+10)?([button setTitleColor:_textSeletedColor forState:UIControlStateNormal]):([button setTitleColor:_textNormalColor forState:UIControlStateNormal]);
        }
        
        if (_delegate &&[_delegate respondsToSelector:@selector(piecewiseView:index:)]){
            [self.delegate piecewiseView:self index:sender.tag - 10];
        }
        
    }
    
}



@end
