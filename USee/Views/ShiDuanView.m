//
//  ShiDuanView.m
//  LOSBi
//
//  Created by JJT on 16/8/18.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "ShiDuanView.h"
#import "UIDatePickerView.h"
#import "MBProgressHUD.h"

@interface ShiDuanView ()<UIGestureRecognizerDelegate, MBProgressHUDDelegate>
{
    
    NSMutableArray * upArr;
    NSMutableArray * downArr;
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSDate *tempDate;

@property (nonatomic,strong) UILabel * textLab;
@property (nonatomic,strong)UIPickerView *datePicker;
@property (strong, nonatomic) NSString *strDate;

@property (strong, nonatomic) UIButton *disBtn;

@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;

@end

@implementation ShiDuanView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self showShiduan];
    }
    return self;
}

-(void)showShiduan{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kvo_bxAry:) name:@"shijianduan" object:nil];// 创建观察者KVO
    
    
    upArr = [NSMutableArray new];
    
    downArr = [NSMutableArray new];
    
    for (int i =0; i< 3; i++) {
        
        self.uptextField =[[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -40* SCREEN_W_SP) / 3 * i + 10* SCREEN_W_SP * (i +1), 20* SCREEN_H_SP, (SCREEN_WIDTH -40* SCREEN_W_SP) / 3 , 40 * SCREEN_W_SP)];

        self.uptextField.backgroundColor = [UIColor colorWithHex:0x613b3b];
        self.uptextField.layer.cornerRadius = 3;
        self.uptextField.clipsToBounds = YES;
        self.uptextField.text = @"";
        self.uptextField.textAlignment = NSTextAlignmentCenter;
        self.uptextField.textColor = [[UIColor colorWithHex:0xffffff] colorWithAlphaComponent:0.5];
        self.uptextField.userInteractionEnabled = YES;
        self.uptextField.textAlignment = NSTextAlignmentCenter;
        
        self.uptextField.rightViewMode = UITextFieldViewModeAlways;
        
        [self addSubview:self.uptextField];
        
        self.upLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40 * SCREEN_W_SP, 40 * SCREEN_H_SP)];
        
        self.upLab.textAlignment = NSTextAlignmentCenter;
        
        self.upLab.font = [UIFont systemFontOfSize:17];
        
        self.upLab.textColor = [UIColor colorWithHex:0xffffff];

        
        if (i == 0) {
           
             self.upLab.text = @"年";
        }if (i == 1) {
            
            self.upLab.text = @"月";
        }if (i == 2) {
            
            self.upLab.text = @"日";
        }
        
        self.uptextField.rightView =self.upLab;
        
        
        [upArr addObject:self.uptextField];
        
        
    }
    
    
    _upView = [[UIView alloc]initWithFrame:CGRectMake(10* SCREEN_W_SP, 20* SCREEN_H_SP, SCREEN_WIDTH - 20* SCREEN_W_SP, 40 * SCREEN_W_SP)];
    
    [self addSubview:_upView];

    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_upView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    
    self.textLab.frame = CGRectMake(100, self.uptextField.frame.origin.y + 50 * SCREEN_H_SP, SCREEN_WIDTH - 200, 30* SCREEN_H_SP);
    [self addSubview:self.textLab];
    
    for (int j =0; j<3; j++) {
        
        self.downtextField =[[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -40* SCREEN_W_SP) / 3 * j + 10* SCREEN_W_SP * (j +1), self.textLab.frame.origin.y + 40 * SCREEN_H_SP, (SCREEN_WIDTH -40* SCREEN_W_SP) / 3, 40 * SCREEN_W_SP)];
        
        self.downtextField.backgroundColor = [UIColor colorWithHex:0x613b3b];
        self.downtextField.layer.cornerRadius = 3;
        self.downtextField.clipsToBounds = YES;
        self.downtextField.text = @"";
        self.downtextField.textAlignment = NSTextAlignmentCenter;
        self.downtextField.textColor = [[UIColor colorWithHex:0xffffff] colorWithAlphaComponent:0.5];
        self.downtextField.userInteractionEnabled = YES;
        self.downtextField.textAlignment = NSTextAlignmentCenter;
        self.downtextField.rightViewMode = UITextFieldViewModeAlways;
        
        [self addSubview:self.downtextField];
        
        self.downLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40 * SCREEN_W_SP, 40 * SCREEN_H_SP)];
        
        self.downLab.textAlignment = NSTextAlignmentCenter;
        
        self.downLab.font = [UIFont systemFontOfSize:17];
        
        self.downLab.textColor = [UIColor colorWithHex:0xffffff];
        
        if (j == 0) {
            
            self.downLab.text = @"年";
        }if (j == 1) {
            
            self.downLab.text = @"月";
        }if (j == 2) {
            
            self.downLab.text = @"日";
        }
        
        self.downtextField.rightView =self.downLab;
        
        [downArr addObject:self.downtextField];
        
    }
    
    _downView = [[UIView alloc]initWithFrame:CGRectMake(10* SCREEN_W_SP, self.textLab.frame.origin.y + 40 * SCREEN_H_SP, SCREEN_WIDTH - 20* SCREEN_W_SP, 40 * SCREEN_W_SP)];
    
    [self addSubview:_downView];
    
    UITapGestureRecognizer* singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_downView addGestureRecognizer:singleTap1];
    singleTap1.delegate = self;
    singleTap1.cancelsTouchesInView = NO;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, self.downtextField.frame.origin.y + 50 * SCREEN_H_SP, SCREEN_WIDTH - 10, 1)];
    line.backgroundColor = [UIColor colorWithHex:0x613b3b];
    [self addSubview:line];
    
    self.disBtn.center = CGPointMake(SCREEN_WIDTH / 2,line.frame.origin.y + 20 * SCREEN_H_SP);
    self.disBtn.bounds = CGRectMake(0, 0, 50, 30* SCREEN_H_SP);
    
    [self addSubview:self.disBtn];
    
    
}

- (UIButton *)disBtn{
    if (!_disBtn) {
        
        self.disBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.disBtn setImage:[UIImage imageNamed:@"CalanderHandle"] forState:UIControlStateNormal];
        [self.disBtn addTarget:self action:@selector(disBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _disBtn;
    
}

-(UILabel *)textLab{
    if (!_textLab) {
        self.textLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.textLab.font = [UIFont systemFontOfSize:17];
        self.textLab.text = @"至";
        self.textLab.textAlignment = NSTextAlignmentCenter;
        self.textLab.textColor = [[UIColor colorWithHex:0xffffff] colorWithAlphaComponent:0.5];
    }
    
    return _textLab;
}


#pragma mark - 上部两个view点击手势回调
- (void)handleSingleTap:(UITapGestureRecognizer *)sender{
    
    UIDatePickerView *picker = [[UIDatePickerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self addSubview:picker];
    
    [picker showUIDatePicker];
    
    if (sender.view == _upView) {
        
         self.flog = NO;
        
    }else if (sender.view == _downView){

          self.flog = YES;
          
    }
    
}


#pragma mark - 点击确定回调

- (void)kvo_bxAry:(NSNotification *)sender{
    
    NSDate *date = sender.object;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
    [dateFormatter setDateFormat:@"yyyy"];//四个y就是2014－10-15，这是输出字符串的时候用到的
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];//设置输出的格式
    [dateFormatter1 setDateFormat:@"MM"];//四个y就是2014－10-15，这是输出字符串的时候用到的
    NSString *destDateString1 = [dateFormatter1 stringFromDate:date];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];//设置输出的格式
    [dateFormatter2 setDateFormat:@"dd"];//四个y就是2014－10-15，这是输出字符串的时候用到的
    NSString *destDateString2 = [dateFormatter2 stringFromDate:date];

    if (self.flog == NO) {
        //up
        self.fromDate = date;
        
        UITextField * tf1 =  upArr[0];
        
        tf1.text = destDateString;
        
        UITextField * tf2 =  upArr[1];
        
        tf2.text = destDateString1;
      
        UITextField * tf3 =  upArr[2];
        
        tf3.text = destDateString2;
        

    }else if (self.flog == YES){

        self.toDate = date;
        
        UITextField * tf1 =  downArr[0];
        
        tf1.text = destDateString;
        
        UITextField * tf2 =  downArr[1];
        
        tf2.text = destDateString1;
        
        UITextField * tf3 =  downArr[2];
        
        tf3.text = destDateString2;
        
    }
    
    if(self.fromDate && self.toDate
       && self.fromDate.timeIntervalSince1970 > self.toDate.timeIntervalSince1970){
        
        HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
        HUD.delegate = self;
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = @"起始时间必须小于结束时间";
        HUD.margin = 10.f;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES afterDelay:2];
        
    }
    
}

#pragma mark -
#pragma mark HUD的代理方法,关闭HUD时执行
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

-(void)disBtn:(UIButton *)sender{
    
    if (self.fromDate && self.toDate
        && self.fromDate.timeIntervalSince1970 <= self.toDate.timeIntervalSince1970) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationForSelectDate object:@{@"fromDate":self.fromDate, @"toDate":self.toDate}];
    }
    
    self.fromDate = nil;
    
    self.toDate = nil;
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"dismis" object:nil];
}

@end
