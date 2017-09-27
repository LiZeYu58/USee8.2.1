//
//  BigAndTimeView.m
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



    //subheadBar ＋ 日周月年 ＋ 搜索框 的封装



#import "BigAndTimeView.h"

#import "LOSHelper.h"


@interface BigAndTimeView ()<UIScrollViewDelegate>
{

    UIImageView *leftArrowView;
    UIImageView *rightArrowView;
    NSInteger previousTapedTag;

}



@end


@implementation BigAndTimeView


-(void)showBigAndTimeView:(NSArray *)arr WithState:(BOOL)bol Withplaceholder:(NSString *)placeholder WithTimeArray:(NSArray *)timeArr withIndexOfSubheadBar:(NSInteger)indexOfSubHeadBar withIndexOfTime:(NSInteger)indexOfTime  scrollViewTag:(NSInteger)tag{
    
    
    _numArr = [NSArray arrayWithArray:arr];
    
    _array = [NSMutableArray new];
    
    self.ScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,60 * SCREEN_H_SP)];
    self.ScrollView.delegate = self;
    self.ScrollView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    
    for (int i = 0; i< arr.count; i++) {
        
        self.upBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * i, 10* SCREEN_H_SP, SCREEN_WIDTH / 4, 50* SCREEN_H_SP)];
        
        [self.upBtn setTitle:arr[i] forState:UIControlStateNormal];
        
        [self.upBtn setBackgroundColor:[UIColor colorWithHex:0xdfdfdf] forState:UIControlStateNormal];
        
        [self.upBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [self.upBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.upBtn setTitleColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
        
        [self.upBtn addTarget:self action:@selector(btn_UpSel:) forControlEvents:UIControlEventTouchUpInside];
        
        self.upBtn.tag = 10 + i;
        
        if (i == indexOfSubHeadBar) {
            
            self.upBtn.selected = YES;
            
        }
        
        [_array addObject:self.upBtn];
        
        [self.ScrollView addSubview:self.upBtn];
        
    }
    
    
//    self.ScrollView.contentSize=CGSizeMake(SCREEN_WIDTH * 3,0);
    self.ScrollView.contentSize = CGSizeMake(SCREEN_WIDTH / 4 *arr.count + 15*SCREEN_W_SP, 0);
    
    self.ScrollView.scrollEnabled = YES;
    self.ScrollView.showsHorizontalScrollIndicator=NO;
    self.ScrollView.showsVerticalScrollIndicator=NO;
    [self addSubview:self.ScrollView];
    self.ScrollView.tag = tag;
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setImage:[UIImage imageNamed:@"icon_滚动箭头_R"] forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - 20, 0, 20, 60* SCREEN_H_SP);
    self.rightBtn.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    if (arr.count <= 4) {
        self.rightBtn.hidden = YES;
    }
    
    
    
    
    if (arr.count > 4) {
        
        UIImage *leftArrow = [UIImage imageNamed:@"icon_滚动箭头_L"];
        UIImage *rightArrow = [UIImage imageNamed:@"icon_滚动箭头_R"];
        leftArrowView = [[UIImageView alloc]initWithImage:leftArrow];
        rightArrowView = [[UIImageView alloc]initWithImage:rightArrow];
        [leftArrowView setFrame:CGRectMake(5 * SCREEN_W_SP, self.ScrollView.height / 2 - leftArrow.size.height / 2 + 5*SCREEN_H_SP, leftArrow.size.width, leftArrow.size.height)];
        [rightArrowView setFrame:CGRectMake(SCREEN_WIDTH - rightArrow.size.width - 5 * SCREEN_W_SP, self.ScrollView.height / 2 - leftArrow.size.height / 2 + 5 *SCREEN_H_SP, rightArrow.size.width, rightArrow.size.height)];
        leftArrowView.hidden = YES;
        
        [self addSubview:leftArrowView];
        [self addSubview:rightArrowView];
        
    }

    
    
    
    [self.rightBtn addTarget:self action:@selector(rightBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.rightBtn];
    
    self.lefttBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lefttBtn setImage:[UIImage imageNamed:@"icon_滚动箭头_L"] forState:UIControlStateNormal];
    self.lefttBtn.frame = CGRectMake(0, 0, 20, 60* SCREEN_H_SP);
    self.lefttBtn.hidden = YES;
    self.lefttBtn.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    [self.lefttBtn addTarget:self action:@selector(leftBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.lefttBtn];
    
    _downArr = [NSMutableArray new];
    
    for (int j = 0; j< timeArr.count; j++) {
        
        self.downBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / timeArr.count * j + 10* SCREEN_W_SP, self.ScrollView.frame.origin.y + 70* SCREEN_H_SP, SCREEN_WIDTH / timeArr.count - 20* SCREEN_W_SP, 30* SCREEN_H_SP)];
        
        [self.downBtn setTitle:timeArr[j] forState:UIControlStateNormal];
        
        [self.downBtn setBackgroundColor:[UIColor colorWithHex:0xdfdfdf] forState:UIControlStateNormal];
        
        [self.downBtn setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
        
        [self.downBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [self.downBtn addTarget:self action:@selector(btn_DownSel:) forControlEvents:UIControlEventTouchUpInside];
        
        self.downBtn.tag = 18720 + j;
        
        if (j == indexOfTime) {
            
            previousTapedTag = 18720 + j;
            self.downBtn.selected = YES;
        }
        
        [_downArr addObject:self.downBtn];
        
        [self addSubview:self.downBtn];
    }
    
}


-(void)showRegionAndShoppingGuideBigAndTimeView:(NSArray *)arr WithState:(BOOL)bol Withplaceholder:(NSString *)placeholder WithTimeArray:(NSArray *)timeArr withIndexOfSubheadBar:(NSInteger)indexOfSubHeadBar withIndexOfTime:(NSInteger)indexOfTime  scrollViewTag:(NSInteger)tag{
    
    _numArr = [NSArray arrayWithArray:arr];
    
    _array = [NSMutableArray new];
    
    self.ScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,60 * SCREEN_H_SP)];
    self.ScrollView.delegate = self;
    self.ScrollView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    
    for (int i = 0; i< arr.count; i++) {
        
        self.upBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * i, 10* SCREEN_H_SP, SCREEN_WIDTH / 4, 50* SCREEN_H_SP)];
        
        [self.upBtn setTitle:arr[i] forState:UIControlStateNormal];
        
        [self.upBtn setBackgroundColor:[UIColor colorWithHex:0xdfdfdf] forState:UIControlStateNormal];
        
        [self.upBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [self.upBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.upBtn setTitleColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
        
        [self.upBtn addTarget:self action:@selector(btn_UpSel:) forControlEvents:UIControlEventTouchUpInside];
        
        self.upBtn.tag = 10 + i;
        
        if (i == indexOfSubHeadBar) {
            
            self.upBtn.selected = YES;
            
        }
        
        [_array addObject:self.upBtn];
        
        [self.ScrollView addSubview:self.upBtn];
        
    }
    
    
    //    self.ScrollView.contentSize=CGSizeMake(SCREEN_WIDTH * 3,0);
    self.ScrollView.contentSize = CGSizeMake(SCREEN_WIDTH / 4 *arr.count + 15*SCREEN_W_SP, 0);
    
    self.ScrollView.scrollEnabled = YES;
    self.ScrollView.showsHorizontalScrollIndicator=NO;
    self.ScrollView.showsVerticalScrollIndicator=NO;
    [self addSubview:self.ScrollView];
    self.ScrollView.tag = tag;
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setImage:[UIImage imageNamed:@"icon_滚动箭头_R"] forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - 20, 0, 20, 60* SCREEN_H_SP);
    self.rightBtn.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    if (arr.count <= 4) {
        self.rightBtn.hidden = YES;
    }
    
    
    
    
    if (arr.count > 4) {
        
        UIImage *leftArrow = [UIImage imageNamed:@"icon_滚动箭头_L"];
        UIImage *rightArrow = [UIImage imageNamed:@"icon_滚动箭头_R"];
        leftArrowView = [[UIImageView alloc]initWithImage:leftArrow];
        rightArrowView = [[UIImageView alloc]initWithImage:rightArrow];
        [leftArrowView setFrame:CGRectMake(5 * SCREEN_W_SP, self.ScrollView.height / 2 - leftArrow.size.height / 2 + 5*SCREEN_H_SP, leftArrow.size.width, leftArrow.size.height)];
        [rightArrowView setFrame:CGRectMake(SCREEN_WIDTH - rightArrow.size.width - 5 * SCREEN_W_SP, self.ScrollView.height / 2 - leftArrow.size.height / 2 + 5 *SCREEN_H_SP, rightArrow.size.width, rightArrow.size.height)];
        leftArrowView.hidden = YES;
        
        [self addSubview:leftArrowView];
        [self addSubview:rightArrowView];
        
    }
    
    
    
    
    [self.rightBtn addTarget:self action:@selector(rightBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
    //    [self addSubview:self.rightBtn];
    
    self.lefttBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lefttBtn setImage:[UIImage imageNamed:@"icon_滚动箭头_L"] forState:UIControlStateNormal];
    self.lefttBtn.frame = CGRectMake(0, 0, 20, 60* SCREEN_H_SP);
    self.lefttBtn.hidden = YES;
    self.lefttBtn.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    [self.lefttBtn addTarget:self action:@selector(leftBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
    //    [self addSubview:self.lefttBtn];
    
    _downArr = [NSMutableArray new];
    
    for (int j = 0; j< timeArr.count; j++) {
        
        self.downBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / timeArr.count * j + 10* SCREEN_W_SP, self.ScrollView.frame.origin.y + 70* SCREEN_H_SP, SCREEN_WIDTH / timeArr.count - 20* SCREEN_W_SP, 30* SCREEN_H_SP)];
        
        [self.downBtn setTitle:timeArr[j] forState:UIControlStateNormal];
        
        [self.downBtn setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
        
        [self.downBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [self.downBtn addTarget:self action:@selector(btn_DownSel:) forControlEvents:UIControlEventTouchUpInside];
        
        self.downBtn.tag = 18720 + j;
        
        if (j == indexOfTime) {
            
            previousTapedTag = 18720 + j;
            self.downBtn.selected = YES;
        }
        
        [_downArr addObject:self.downBtn];
        
        [self addSubview:self.downBtn];
    }
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.ScrollView.frame.origin.y + 70* SCREEN_H_SP + 30* SCREEN_H_SP + 8 * SCREEN_H_SP, SCREEN_WIDTH, 1)];
    lineLabel.backgroundColor  = Color(238, 238, 238);
    [self addSubview:lineLabel];
    
}



#pragma mark - scrollView回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self scrollViewEnd];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double d1 = scrollView.contentOffset.x;
    
    if (d1+SCREEN_WIDTH > _numArr.count * (SCREEN_WIDTH/4) - 20) {
        
        rightArrowView.hidden = YES;
        leftArrowView.hidden = NO;
        
    } else if ((int)d1 < 10) {
        
        rightArrowView.hidden = NO;
        leftArrowView.hidden = YES;
        
    }

    
    if (scrollView.tag == 1) {
          [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",d1] forKey:@"storeContentOffsetX"];
    }
    else if (scrollView.tag == 2){
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",d1] forKey:@"goodsContentOffsetX"];
    }
    else if (scrollView.tag == 3){
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",d1] forKey:@"linchpinContentOffsetX"];
    }
}

- (void)scrollViewEnd {
    
    //类似于四分之一分页效果
    double d1 = _ScrollView.contentOffset.x;
    
    double d2 = SCREEN_WIDTH / 4;
  //  int s1 = ((int)roundf(d1 / d2)) * d2;
//    [_ScrollView setContentOffset:CGPointMake(s1, 0)animated:YES];
//    
//    //左右箭头展示与否
//   // if (rightArrowView != nil && leftArrowView != nil) {
//        
//        if (d1+SCREEN_WIDTH > _numArr.count * (SCREEN_WIDTH/4) -30) {
//            
//            rightArrowView.hidden = YES;
//            leftArrowView.hidden = NO;
//            
//        } else if ((int)d1 < 10) {
//            
//            rightArrowView.hidden = NO;
//            leftArrowView.hidden = YES;
//            
//       }
//       else if (s1 >= (int)d2 && s1 <= (int)(d2 * (_numArr.count - 1) - SCREEN_WIDTH)) {
//            
//            rightArrowView.hidden = NO;
//            leftArrowView.hidden = NO;
//            
//        }
 //   }
}





-(void)rightBtn_Click:(UIButton *)sender{
    
    double num = _numArr.count - 4;
    
    if (self.ScrollView.contentOffset.x == 0) {
        
        [self.ScrollView setContentOffset:CGPointMake(SCREEN_WIDTH / 4 * num , 0)animated:YES];
        
        self.lefttBtn.hidden = NO;
    }
    self.rightBtn.hidden = YES;
}

-(void)leftBtn_Click:(UIButton *)sender{
    
    if (self.ScrollView.contentOffset.x > 0) {
        [self.ScrollView setContentOffset:CGPointMake(0, 0)animated:YES];
        
        self.rightBtn.hidden = NO;
    }
    
    self.lefttBtn.hidden = YES;
    
}

-(UIView *)upView{
    
    if (!_upView) {
        
        self.upView = [[UIView alloc]initWithFrame:CGRectZero];
        
        self.upView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        
    }
    
    return _upView;
    
}

-(void)btn_UpSel:(UIButton *)sender{
    
    NSInteger num = sender.tag;
    
    for (UIButton *btn in _array) {
        
        btn.selected = NO;
    }
    
    UIButton *btn = (UIButton *)[self viewWithTag:num];
    
    btn.selected = YES;
    
    if (_delegate &&[_delegate respondsToSelector:@selector(headBarView:index:)]){
        [self.delegate headBarView:self index:sender.tag - 10];
    } 
    
}

-(void)btn_DownSel:(UIButton *)sender{
    
    BOOL dosomething = YES;
    //用户类型
    NSInteger userType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] integerValue];
    
    if (self.checkUserType && userType == 2 && sender.tag - 18720 == 3) {
        UIAlertView *freeUserAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"付费用户可用" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [freeUserAlertView show];
        dosomething = NO;
        sender.selected = NO;
        UIButton * btn = (UIButton *)[self viewWithTag:previousTapedTag];
        btn.selected = YES;
        
    } else {
    
        NSInteger num = sender.tag;
        
        for (UIButton *btn in _downArr) {
            
            btn.selected = NO;
        }
        
        UIButton *btn = (UIButton *)[self viewWithTag:num];
        
        btn.selected = YES;
        previousTapedTag = sender.tag;
    }

    if (dosomething && _delegate &&[_delegate respondsToSelector:@selector(bigAndTimeView:index:)]){
        [self.delegate bigAndTimeView:self index:sender.tag - 18720];
    }

}


@end
