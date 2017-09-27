//
//  TimeView.m
//  LOSBi
//
//  Created by JJT on 16/9/16.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TimeView.h"
#import "LOSHelper.h"

@interface TimeView ()
{
    
    NSInteger selectd;
    
}

@property (nonatomic ,strong) UIButton * downBtn;

@property (nonatomic ,strong) NSMutableArray *downArr;

@end

@implementation TimeView

-(void)showTimeBtn{
    
    selectd = 0;
    
    
    self.backgroundColor = [UIColor colorWithHex:0xededed];
    
    _downArr = [NSMutableArray new];
    
    NSArray * timeBtn = @[@"日",@"周",@"月",@"年"];
    
    for (int j = 0; j< 4; j++) {
        
        self.downBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * j + 10 * SCREEN_W_SP, 10 * SCREEN_H_SP, SCREEN_WIDTH / 4 - 20* SCREEN_W_SP, 30* SCREEN_H_SP)];
        
        [self.downBtn setTitle:timeBtn[j] forState:UIControlStateNormal];
        
        [self.downBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.downBtn setBackgroundColor:[UIColor colorWithHex:0xaf2a33] forState:UIControlStateSelected];
        
        [self.downBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [self.downBtn addTarget:self action:@selector(btn_DownSel:) forControlEvents:UIControlEventTouchUpInside];
        
        self.downBtn.tag = 20 + j;
        
        if (j == selectd) {
            
            self.downBtn.selected = YES;
        }
        
        [_downArr addObject:self.downBtn];
        
        [self addSubview:self.downBtn];
    }

}


-(void)btn_DownSel:(UIButton *)sender{
    
    NSInteger num = sender.tag;
    
     selectd = num - 20;
    
    for (UIButton *btn in _downArr) {
        
        btn.selected = NO;
    }
    
    UIButton *btn = (UIButton *)[self viewWithTag:num];
    
    btn.selected = YES;
    
    
    if (_delegate &&[_delegate respondsToSelector:@selector(TimeView:index:)]){
        [self.delegate TimeView:self index:sender.tag - 20];
    }
    
    
}


@end
