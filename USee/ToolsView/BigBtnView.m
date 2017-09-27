//
//  BigBtnView.m
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



    //局部按钮的封装（日周月年）



#import "BigBtnView.h"
#import "LOSHelper.h"

@interface BigBtnView ()
{
    
    NSInteger selected;
    UIColor *backgroundColor;
    
}

@end

@implementation BigBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        selected = BigBtnViewInitSelectedIndex;
        _arr = [NSMutableArray new];
        
    }
    
    return self;
    
}

-(void)showBigBtnView:(NSArray *)array{
    @try {
        selected = 0;
        
        
        _arr = [NSMutableArray new];
        
        self.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        
        for (int i = 0; i< array.count; i++) {
            
            self.btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / array.count * i, 10 * SCREEN_H_SP, SCREEN_WIDTH / array.count, 50 * SCREEN_H_SP)];
            
            [self.btn setTitle:array[i] forState:UIControlStateNormal];
            
            [self.btn setBackgroundColor:[UIColor colorWithHex:0xdfdfdf] forState:UIControlStateNormal];
            
            self.btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [self.btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btn setTitleColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
            [self.btn addTarget:self action:@selector(btn_Did:) forControlEvents:UIControlEventTouchUpInside];
            
            self.btn.tag = i + 10 ;
            
            if (i == selected) {
                
                self.btn.selected = YES;
                
            }
            
            [_arr addObject:self.btn];
            [self addSubview:self.btn];
            
        }

    } @catch (NSException *exception) {
        
    }
}

- (void)generateComponentViewWith:(NSInteger)columnCount {
    @try {
        double splitCount = (int)columnCount;
        NSMutableArray * array = [[NSMutableArray alloc]initWithObjects:@"日",@"周",@"月",@"年", nil];
        
        for (int i = 0; i < (int)columnCount; i++) {
            
            self.btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / splitCount * i, 5 * SCREEN_H_SP, SCREEN_WIDTH / splitCount, 50 * SCREEN_H_SP)];
            [self.btn setBackgroundColor:[UIColor colorWithHex:0xdfdfdf] forState:UIControlStateNormal];
            self.btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [self.btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.btn setTitle:array[i] forState:UIControlStateNormal];
            [self.btn setTitleColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
            [self.btn addTarget:self action:@selector(btn_Did:) forControlEvents:UIControlEventTouchUpInside];
            self.btn.tag = i + 10 ;
            
            if (i == 0) {
                
                self.btn.selected = YES;
                
            }
            
            [_arr addObject:self.btn];
            [self addSubview:self.btn];
            
        }
 
    } @catch (NSException *exception) {
        
    }
    
}

- (void) setTitleWith:(NSArray *)dataList {
    @try {
        
        for (int i = 0; i < dataList.count; i++) {
            
            NSString *title = dataList[i];
            
            if (i < _arr.count) {
                
                UIButton *btn = _arr[i];
                [btn setTitle:title forState:UIControlStateNormal];
                
            }else{
                
                break;
                
            }
            
        }
    } @catch (NSException *exception) {
       
        NSLog(@"崩溃BigBtnView");
    }
}

- (void)setBtnSelectedWithIndex:(NSInteger)index{
    @try {
        
        NSInteger btnTag = index + 10;
        selected = index;
        
        for (UIButton * btn in _arr) {
            
            btn.selected = NO;
            
        }
        
        UIButton *btn = (UIButton *)[self viewWithTag:btnTag];
        btn.selected = YES;

    } @catch (NSException *exception) {
        
    }
}

- (void)btn_Did:(UIButton *)sender{
    
    @try {
        NSInteger num = sender.tag;
        
        selected = num - 10;
        
        for (UIButton * btn in _arr) {
            
            btn.selected = NO;
            
        }
        
        UIButton *btn = (UIButton *)[self viewWithTag:num];
        
        btn.selected = YES;
        
        if (_delegate && [_delegate respondsToSelector:@selector(bigBtnView:index:)]){
            [self.delegate bigBtnView:self index:sender.tag - 10];
        }
 
    } @catch (NSException *exception) {
        
    }
    
}

@end
