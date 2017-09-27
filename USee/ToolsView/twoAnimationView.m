//
//  TwoAnimationView.m
//  USee
//
//  Created by 李泽雨 on 2017/4/12.
//  Copyright © 2017年 L.O.S. All rights reserved.
//

#import "TwoAnimationView.h"

@interface TwoAnimationView ()

{
    
    NSString *name;
    
    NSString *name1;
    
    UILabel * lab;
    
    UILabel * lab1;
    
    UILabel *timeLab;
    
}

@property (strong, nonatomic)  UIImageView *picture;

@property (strong, nonatomic)  UIImageView *picture1;

@end


@implementation TwoAnimationView

-(void)Animation1{
    
    @try {
        _picture1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 55, 0,30, 40)];
        
        [self addSubview:_picture1];
        
        
        lab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 20, 20, 100, 10)];
        lab.textColor = [UIColor colorWithHex:0x888888];
        
        lab.font = [UIFont systemFontOfSize:12];
        
        lab.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:lab];
        
        
        name1 = @"img_下拉上拉_正在刷新";
        
        if ([self.picture1 isAnimating]) {
            return ;
        }
        // 动画图片的数组
        NSMutableArray *arrayM1 = [NSMutableArray array];
        
        // 添加动画播放的图片
        for (int i = 1; i < 15; ++i) {
            
            //        img_下拉刷新_01
            
            // 图像名称
            NSString *imageName = [NSString stringWithFormat:@"%@%02d", name1, i]; // 确保格式eat_01.jpg
            //        NSLog(@"%@", imageName);
            UIImage *image = [UIImage imageNamed:imageName]; // 会内存叠加
            
            [arrayM1 addObject:image];
        }
        // 设置动画数组
        self.picture1.animationImages = arrayM1;
        // 重复一次
        self.picture1.animationRepeatCount = 500;
        // 动画时长
        self.picture1.animationDuration = self.picture.animationImages.count * 0.08;
        
    } @catch (NSException *exception) {
        
    }
    
    
}

-(void)Animation{
    @try {
        _picture = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 55, 0,30, 40)];
        
        [self addSubview:_picture];
        
        
        lab1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 20, 20, 100, 10)];
        
        lab1.textColor = [UIColor colorWithHex:0x888888];
        
        lab1.font = [UIFont systemFontOfSize:12];
        
        lab1.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:lab1];
        
        
        timeLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 70,40, 150,20)];
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString *currentDateString = [dateFormatter stringFromDate:date];
        
        timeLab.text = [NSString stringWithFormat:@"最近更新: %@",currentDateString];
        
        timeLab.textColor = [UIColor colorWithHex:0x888888];
        
        timeLab.font = [UIFont systemFontOfSize:12];
        
        timeLab.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:timeLab];
        
        
        
        name = @"img_下拉刷新";
        
        if ([self.picture isAnimating]) {
            return ;
        }
        // 动画图片的数组
        NSMutableArray *arrayM = [NSMutableArray array];
        
        // 添加动画播放的图片
        for (int i = 1; i < 13; ++i) {
            
            //        img_下拉刷新_01
            
            // 图像名称
            NSString *imageName = [NSString stringWithFormat:@"%@_%02d", name, i]; // 确保格式eat_01.jpg
            //        NSLog(@"%@", imageName);
            UIImage *image = [UIImage imageNamed:imageName]; // 会内存叠加
            //        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
            //        UIImage *image = [UIImage imageWithContentsOfFile:path];
            
            [arrayM addObject:image];
        }
        // 设置动画数组
        self.picture.animationImages = arrayM;
        // 重复一次
        self.picture.animationRepeatCount = (long)4000000000000;
        // 动画时长
        self.picture.animationDuration = self.picture.animationImages.count * 0.15;
        // 开始动画
        
    } @catch (NSException *exception) {
        
    }
}

- (void)clearup {
    @try {
        // self.tom.animationImages = nil;
        [self.picture setAnimationImages:nil];
        
    } @catch (NSException *exception) {
        
    }
}

-(void)startAnimation{
    @try {
        lab.text = @"";
        
        lab1.text = @"松开刷新...";
        
        [self.picture startAnimating];
        
    } @catch (NSException *exception) {
        
    }
}

-(void)stopAnimating{
    
    @try {
        [self.picture stopAnimating];
    } @catch (NSException *exception) {
        
    }
    
}


-(void)startAnimation1{
    
    @try {
        lab1.text = @"";
        
        lab.text = @"正在刷新...";
        
        [self.picture1 startAnimating];
    } @catch (NSException *exception) {
        
    }
    
}

-(void)stopAnimating1{
    
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSDate *date = [NSDate date];
        NSString *currentDateString = [dateFormatter stringFromDate:date];
        timeLab.text = [NSString stringWithFormat:@"最近更新: %@",currentDateString];
        
        [self.picture1 stopAnimating];
        
    } @catch (NSException *exception) {
        
    }
    
}


@end
