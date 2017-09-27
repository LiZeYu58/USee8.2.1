//
//  SlideView.m
//  LOSBi
//
//  Created by JJT on 16/8/26.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



    //侧滑栏



#import "SlideView.h"
#import "LOSHelper.h"
#import "UIView_extra.h"


@implementation SlideView

{
    
    NSMutableArray * array1;
    NSMutableArray * array2;
    NSMutableArray * array3;
    NSMutableArray * array4;
    
    NSMutableDictionary * _linchpinSelectIndexDic;
}

- (void)loadTitleArray:(NSArray *)titleArray arr:(NSInteger)index
{
    _titleArray = titleArray;
    
    self.GoodsIndex = index;
    
    self.StoreRankIndex = index;
    
    self.GoodIndex = index;
    
    
    
    [self loadMainView];
}



- (void)loadTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    
    [self loadMainView];
}

- (void)loadMainView
{
    switch (_type) {
        case LeftViewTypeGoodsRank1:
        {
            [self loadGoodsRankView];
        }
            break;
        case LeftViewTypeKeyPoint1:
        {
            NSString * guanJianString  = [[NSUserDefaults standardUserDefaults] objectForKey:@"guanJianView"];
            
            if ([guanJianString isEqualToString:@"111"]) {
                _linchpinSelectIndexDic = [CommonTools readFile:@"linchpinSelect"];
                
                if (_linchpinSelectIndexDic == nil) {
                    _linchpinSelectIndexDic = [[NSMutableDictionary alloc]init];
                    
                    for (NSInteger i = 0; i < _titleArray.count; i++) {
                        [_linchpinSelectIndexDic setObject:@"a" forKey:[NSString stringWithFormat:@"%ld",(long)i]];
                    }
                    
                    [CommonTools writeFile:_linchpinSelectIndexDic toFile:@"linchpinSelect"];
                }
                
            }

            
            [self loadKeyPointView];
        }
            break;
        case LeftViewTypeStoreRank1:
        {
            [self loadStoreRankView];
            
        }
            break;
        case LeftViewTypeGoods1:
        {
            [self loadGoodsView];
            
        }
            break;
        case LeftViewTypeGuide1:
        {
            [self loadGuideView];
            
        }
            break;
        default:
            break;
    }
    
    self.backgroundColor = [UIColor whiteColor];
}

-(void)loadGuideView{
    
    self.backgroundColor = [UIColor lightGrayColor];
    array4 = [NSMutableArray new];
    
    for (int i = 0; i < _titleArray.count; i++ ) {
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 40 * i + 1 *i , self.size.width, 40)];
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn1 setBackgroundColor:[UIColor colorWithHex:0xdfdfdf] forState:UIControlStateNormal];
        [btn1 setBackgroundColor:ColorThemeRed forState:UIControlStateSelected];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn1 setTitle:_titleArray[i] forState:UIControlStateNormal];
        btn1.tag = 100 + i;
        if (i == 0) {
            btn1.selected=YES;
        }
        [array4 addObject:btn1];
        [btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];
    }
    
}


-(void)loadGoodsView{
    
    self.backgroundColor = [UIColor lightGrayColor];
    array3 = [NSMutableArray new];
    
    for (int i = 0; i < _titleArray.count; i++ ) {
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 40 * i + 1 *i , self.size.width, 40)];
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn1 setBackgroundColor:[UIColor colorWithHex:0xdfdfdf] forState:UIControlStateNormal];
        [btn1 setBackgroundColor:ColorThemeRed forState:UIControlStateSelected];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn1 setTitle:_titleArray[i] forState:UIControlStateNormal];
        btn1.tag = 54088 + i;
        if (i == self.GoodIndex) {
            btn1.selected=YES;
        }
        [array3 addObject:btn1];
        [btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];
    }
    
}


-(void)loadGoodsRankView{
    self.backgroundColor = [UIColor lightGrayColor];
    array2 = [NSMutableArray new];
    for (int i = 0; i < _titleArray.count; i++ ) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 40 * i + 1 *i , self.size.width, 40)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setBackgroundColor:[UIColor colorWithHex:0xdfdfdf] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        if (i == self.GoodsIndex) {
            btn.selected=YES;
        }
        [array2 addObject:btn];
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

-(void)loadKeyPointView{
    
    [self removeAllSubviews];
    
    self.backgroundColor = [UIColor lightGrayColor];
    for (int i = 0; i < _titleArray.count; i++ ) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 40 * i + 1 *i  , self.size.width, 40)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setBackgroundColor:[UIColor colorWithHex:0xdfdfdf] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        btn.selected=YES;
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

-(void)loadStoreRankView{
    self.backgroundColor = [UIColor whiteColor];
    array1 = [NSMutableArray new];
    for (int i = 0; i < _titleArray.count; i++ ) {
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 40 * i + 1 *i, self.size.width, 40)];
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn1 setBackgroundColor:[UIColor colorWithHex:0xdfdfdf] forState:UIControlStateNormal];
        [btn1 setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn1 setTitle:_titleArray[i] forState:UIControlStateNormal];
        btn1.tag = 100 + i;
        if (i == self.StoreRankIndex) {
            btn1.selected=YES;
        }
        [array1 addObject:btn1];
        [btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];
    }
}


- (void)buttonPressed:(UIButton *)sender
{
    
    //用户类型
    NSInteger userType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] integerValue];
    UIAlertView *freeUserAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"付费用户可用" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    BOOL dosomething = YES;
    
    switch (_type) {
        case LeftViewTypeStoreRank1:
        {
            if (sender.selected == NO && userType == 2) {
                [freeUserAlertView show];
                UIButton *firstButton = (UIButton *)[self viewWithTag:100];
                firstButton.selected = YES;
                sender.selected = NO;
                dosomething = NO;
                break;
            }
            for (UIButton *btn in array1) {
                btn.selected = NO;
            }
            sender.selected = YES;
            
        }
            break;
        case LeftViewTypeKeyPoint1:
        {
            sender.selected = !sender.selected;
            
            if (sender.selected) {
                 [_linchpinSelectIndexDic setObject:@"a" forKey:[NSString stringWithFormat:@"%ld",(long)sender.tag - 100]];
                
                [sender setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
                [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            }else if (!sender.selected){
                 [_linchpinSelectIndexDic setObject:@"" forKey:[NSString stringWithFormat:@"%ld",(long)sender.tag - 100]];
                
                [sender setBackgroundColor:[UIColor colorWithHex:0xdfdfdf] forState:UIControlStateNormal];
                [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
            
            [CommonTools writeFile:_linchpinSelectIndexDic toFile:@"linchpinSelect"];
            
        }
            break;
        case LeftViewTypeGoodsRank1:
        {
            if (sender.selected == NO && userType == 2) {
                [freeUserAlertView show];
                UIButton *firstButton = (UIButton *)[self viewWithTag:100];
                firstButton.selected = YES;
                sender.selected = NO;
                dosomething = NO;
                break;
            }
            for (UIButton *btn in array2) {
                btn.selected = NO;
            }
            sender.selected = YES;
        }
            break;
            
        case LeftViewTypeGoods1:
        {
            if (sender.selected == NO && userType == 2) {
                [freeUserAlertView show];
                UIButton *firstButton = (UIButton *)[self viewWithTag:100];
                firstButton.selected = YES;
                sender.selected = NO;
                dosomething = NO;
                break;
            }
            for (UIButton *btn in array3) {
                btn.selected = NO;
            }
            sender.selected = YES;
        }
            break;
        case LeftViewTypeGuide1:
        {
            for (UIButton *btn in array4) {
                btn.selected = NO;
            }
            sender.selected = YES;
        }
            break;

        default:
            break;
    }
    
    if (dosomething && _delegate && [_delegate respondsToSelector:@selector(piecewiseView:index:)]) {
        
        if (_type == LeftViewTypeGoods1) {
            
            [self.delegate piecewiseView:self index:sender.tag - 54088];
            
        } else {
            
            [self.delegate piecewiseView:self index:sender.tag - 100];
            
        }
        
    }
    
}


@end
