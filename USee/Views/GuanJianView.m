//
//  GuanJianView.m
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.



    //关键指标（二级页面）



#import "GuanJianView.h"
#import "BigAndTimeView.h"
//#import "Charts.h"
#import "LOSAFNetworking.h"
#import "AppDatas.h"
#import "LOSHelper.h"
#import "TableViewCellForGuanJianCell.h"

#import "AnimationView.h"
//ChartViewDelegate,
@interface GuanJianView ()<BigAndTimeViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

{
    NSDictionary *_selectBagDic;
    
    UIView * view;
    
    BigAndTimeView * bigview;
    
    NSInteger _bigSelectIndex;
    
    NSInteger _smailSelectIndex;
    
    UIView * downView;
    
    UITableView * tableViews ;
    
    UIButton * _cruxdrillUpButton;
    UIButton * _cruxdrillDownButton;
    
    TableViewCellForGuanJianCell * cell;
    
    NSString *s;
    NSString *_tempString;
    
    NSString * _cruxDrill_type;
    
    NSInteger first;   //第一次走，创建UI,之后不创建

    
     UIScrollView * scrollView1;
    
    AnimationView * animationView;
    
    NSInteger firstCreate;
    
}

//@property (nonatomic, strong) LineChartView *chartView;
//@property (nonatomic, strong) LineChartView *chartView1;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSDictionary *dataDic1;
@property (nonatomic, strong) NSDictionary *dataDic2;
@property (nonatomic, strong) NSMutableArray *titArray;
@property (nonatomic, strong) NSMutableArray *codeArray;
@property (nonatomic, strong) NSMutableArray *uptitArray;
@property (nonatomic, strong) NSMutableArray *upNumArray;
@property (nonatomic, strong) NSMutableArray *upSignArray;
@property (nonatomic, strong) NSMutableArray *indexOfLeftSelectedArray;
@property (nonatomic, strong) NSMutableArray * values1;
@property (nonatomic, strong) NSMutableArray * values2;
@property (nonatomic, strong) NSMutableArray * values11;
@property (nonatomic, strong) NSMutableArray * values22;
@property (nonatomic, strong) NSMutableArray * xValueArr;


@end

@implementation GuanJianView


#pragma mark - 懒加载
-(NSMutableArray *)indexOfLeftSelectedArray{
    
    if (!_indexOfLeftSelectedArray) {
        
        _indexOfLeftSelectedArray = nil;
        _indexOfLeftSelectedArray = [NSMutableArray new];
    }
    return _indexOfLeftSelectedArray;
}

-(NSMutableArray *)values1{
    if (!_values1) {
        _values1 = nil;
        _values1 = [NSMutableArray new];
    }
    return _values1;
}

-(NSMutableArray *)values2{
    if (!_values2) {
        _values2 = nil;
        _values2 = [NSMutableArray new];
    }
    return _values2;
}

-(NSMutableArray *)titArray{
    if (!_titArray) {
        _titArray = nil;
        _titArray = [NSMutableArray new];
    }
    return _titArray;
}

-(NSMutableArray *)uptitArray{
    if (!_uptitArray) {
        _uptitArray = nil;
        _uptitArray = [NSMutableArray new];
    }
    return _uptitArray;
}

-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"linchpinContentOffsetX"];
        first = 1;
        
        firstCreate = 1;
        
        _cruxDrill_type = @"0";
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ForGuanJian:) name:@"afterCloseLeft" object:nil];

        
    }
    
    return self;
}


//通知方法
-(void)DetailVCTitleCodeToGuanJianView:(NSString *)orgCode{
    
    @try {
        //    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        firstCreate = 1;
        _Code = orgCode;
        
        _bigSelectIndex = 0;

        if (_selectBagDic.count > 1) {
            [self refreshDatasWithCache:YES WithPiarry:_tempString WithCode:_Code];
        }
        else{
            [self refreshDatasWithCache:YES WithPiarry:s WithCode:_Code];
        }
        
 
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 通知方法
- (void)keyRank:(NSDate *)fromDate :(NSDate *)toDate{
    
    @try {        
        //  [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        [AppDatas sharedDatas].selectFromDate = fromDate;
        [AppDatas sharedDatas].selectToDate = toDate;
        
        
        if (_selectBagDic.count > 1) {
            [self refreshDatasWithCache:YES WithPiarry:_tempString WithCode:_Code];
        }
        else{
            [self refreshDatasWithCache:YES WithPiarry:s WithCode:_Code];
        }
        
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - 接口请求过渡方法
- (void)refreshDatasWithCache:(BOOL)isUseCache WithPiarry:pia WithCode:Code{
    
    @try {
        
        [self requestDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                            toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                            withCache:isUseCache WithPiarry:pia WithCode:Code];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - 点击底部bar请求 通知方法
- (void)orgCodeToGuanJian:(NSString *)orgCode{
    
    @try {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
        _selectBagDic = [[NSMutableDictionary alloc] init];
        
        //   [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        firstCreate  = 1;
        _bigSelectIndex = 0;
        
        _Code = orgCode;
        
        [self requestData2];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

//通知方法
-(void)ForGuanJian:(NSNotification *)sender{
    
    @try {
     
        _selectBagDic = sender.object;
        
        NSDictionary * tempObj = _selectBagDic[@"aa"];
        if (tempObj.count == 0) {
            _tempString  = _selectBagDic[@"keyPoint"];
            _upSignArray = _selectBagDic[@"unitArray"];
            _uptitArray = _selectBagDic[@"nameArray"];
        }
        else{
            _tempString  = tempObj[@"keyPoint"];
            _upSignArray = tempObj[@"unitArray"];
            _uptitArray = tempObj[@"nameArray"];
        }
        
        NSMutableDictionary * linchpinSelectIndexDic = [CommonTools readFile:@"twoLinchpin"];
        
        NSMutableDictionary * readLinchpinSelectIndexDic = [CommonTools readFile:@"linchpinSelect"];
        
        NSString  * vauleString  = [[NSUserDefaults standardUserDefaults] objectForKey:@"linchpinCount"];
        
        NSInteger vauleInt = [vauleString integerValue];
        
        if (!linchpinSelectIndexDic) {
            linchpinSelectIndexDic = [[NSMutableDictionary alloc] init];
            
            for (NSInteger i = 0; i < vauleInt; i ++) {
                
                [linchpinSelectIndexDic setObject:@"a" forKey:[NSString stringWithFormat:@"%ld",(long)i]];
            }
        }
        
        for (NSInteger i = 0; i < vauleInt; i ++) {
            
            NSString * intString =  [linchpinSelectIndexDic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
            NSString * twoIntString = [readLinchpinSelectIndexDic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
            
            if (![intString isEqualToString:twoIntString]) {
                
                
                //    _indexOfLeftSelectedArray = tempObj[@"indexOfSelected"];
                
                if (_selectBagDic.count > 1) {
                    [self refreshDatasWithCache:YES WithPiarry:_tempString WithCode:_Code];
                }
                else{
                    [self refreshDatasWithCache:YES WithPiarry:s WithCode:_Code];
                }
                
                linchpinSelectIndexDic = [[NSMutableDictionary alloc] initWithDictionary:readLinchpinSelectIndexDic];
                
                [CommonTools writeFile:linchpinSelectIndexDic toFile:@"twoLinchpin"];
                
                return;
            }
            
        }
        linchpinSelectIndexDic = [[NSMutableDictionary alloc] initWithDictionary:readLinchpinSelectIndexDic];
        
        [CommonTools writeFile:linchpinSelectIndexDic toFile:@"twoLinchpin"];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


#pragma mark - 接口请求 侧滑栏
-(void)requestData2{
    
    @try {
     
#pragma mark  检查网络
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
             NSDictionary * requestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                 [AppDatas sharedDatas].userCode,@"user_code",
                 nil];
                
                [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.KPIBoardLeftSidebar"
                             dataParameters:requestDic
                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                                
                                                self.dataDic1 = responseDic;
                                                
                                                [self createGuanJian];
                                                
                                            }
                                            else{
                                                
                                                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                                            }
                                            
                                        });
                                    }
                                    failure:^(NSError *error) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            
                                            if (error.code == -1001) {
                                                
                                                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
                                                
                                            }else{
                                                
                                                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                                            }
                                        });
                                    }];
            });
        }
        else{
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 请求成功后 数据处理
-(void)createGuanJian{
    
    @try {
        
        NSArray * titNum = self.dataDic1[@"data"][@"leftSidebar"];
        
        NSMutableArray * PICodeArr = [NSMutableArray new];
        NSMutableArray * PINameArr = [NSMutableArray new];
        NSMutableArray * PIUnitArr = [NSMutableArray new];
        
        NSMutableDictionary *PICodeDic = [NSMutableDictionary dictionaryWithCapacity:10];
        
        NSMutableArray *aa = [NSMutableArray array];
        
        for (int i =0; i < titNum.count; i++) {
            
            NSString * str = titNum[i][@"PIName"];
            NSString * str1 = titNum[i][@"PICode"];
            NSString * str2 = titNum[i][@"PIUnit"];
            
            [PICodeArr addObject:str1];
            [PINameArr addObject:str];
            [PIUnitArr addObject:str2];
            
            [PICodeDic setObject:str1 forKey:[NSString stringWithFormat:@"%d", i]];
            
            [aa addObject:@(1)];
            
        }
        
        //    if (!_uptitArray) {
        
        _uptitArray = PINameArr;
        _upSignArray = PIUnitArr;
        _indexOfLeftSelectedArray = aa;
        
        //    }else{
        
        //        aa = _indexOfLeftSelectedArray;
        //        PINameArr = _uptitArray;
        //        PIUnitArr = _upSignArray;
        //    }
        
        
        //发送给左侧边栏的数组
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:PINameArr,@"GuanJianleftName",PICodeDic,@"GuanJianleftPiaCode",aa,@"GuanJianleftPiaa",titNum,@"dic",PIUnitArr,@"PIUnitArr",nil];
        NSNotification *notification =[NSNotification notificationWithName:@"GuanJianLeftSidebarArray" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        s = @"";
        for (int i = 0; i< PICodeArr.count; i++) {
            
            if (i == PICodeArr.count - 1) {
                
                s = [s stringByAppendingString:PICodeArr[i]];
                
            }else{
                
                s = [s stringByAppendingString:PICodeArr[i]];
                
                s =[s stringByAppendingString:@","];
            }
            
        }
        
#pragma mark - 发送给 slideVC，以代替关闭侧边栏时保存的数据
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ToSlideVCAndReplaceLeftDatas" object:[NSDictionary dictionaryWithObjectsAndKeys: s,@"keyPoint",PIUnitArr,@"unitArray",PINameArr,@"nameArray", nil]];
        
        
        if (_selectBagDic.count > 1) {
            [self refreshDatasWithCache:YES WithPiarry:_tempString WithCode:_Code];
        }
        else{
            [self refreshDatasWithCache:YES WithPiarry:s WithCode:_Code];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
    
    }
    
}

-(void)createUI{
    
    @try {
       
        [scrollView1 removeFromSuperview];
        scrollView1 = nil;
        
        if (SCREEN_HEIGHT == 812) {
             scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 89, SCREEN_WIDTH, self.height)];
        }
        else{
             scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.height)];
        }
        scrollView1.delegate =self;
        
        scrollView1.showsVerticalScrollIndicator = NO;
        
        scrollView1.contentSize = CGSizeMake(0, self.height + 10*SCREEN_H_SP);
        
        [self addSubview:scrollView1];
        
        [animationView removeFromSuperview];
        animationView = nil;
        
        animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -80, SCREEN_WIDTH, 100)];
        
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        
        
        [animationView Animation];
        
        [animationView Animation1];
        
        [scrollView1 addSubview:animationView];
        
        
        [bigview  removeFromSuperview];
        bigview  = nil;
        
        bigview = [[BigAndTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100 * SCREEN_H_SP )];
        
        bigview.delegate = self;
        
        NSArray * titNum = self.dataDic2[@"data"][@"subheadSidebar"];
        
        _titArray = nil;
        _titArray = [NSMutableArray new];
        
        _codeArray = nil;
        _codeArray = [NSMutableArray new];
        
        for (int i =0; i < titNum.count; i++) {
            
            NSString * str = titNum[i][@"name"];
            
            NSString * codeStr = titNum[i][@"code"];
            
            [_codeArray addObject:codeStr];
            
            [_titArray addObject:str];
        }
        
        NSArray * timeBtnArr = @[@"日",@"周",@"月",@"年"];
        
        [bigview showBigAndTimeView:_titArray WithState:YES Withplaceholder:nil WithTimeArray:timeBtnArr withIndexOfSubheadBar:_bigSelectIndex withIndexOfTime:_smailSelectIndex scrollViewTag:3];
        [scrollView1 addSubview:bigview];
        
        
        [_cruxdrillUpButton removeFromSuperview];
        _cruxdrillUpButton = nil;
        
        _cruxdrillUpButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _cruxdrillUpButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
        [bigview addSubview:_cruxdrillUpButton];
        if (SCREEN_WIDTH == 320) {
            _cruxdrillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 35, 70* SCREEN_H_SP, 40, 28* SCREEN_H_SP);
        }
        else if (SCREEN_WIDTH >= 414){
            _cruxdrillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 18, 70* SCREEN_H_SP, 45, 28* SCREEN_H_SP);
        }
        else if(SCREEN_WIDTH >= 375 && SCREEN_WIDTH < 414){
            _cruxdrillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 22,  70* SCREEN_H_SP, 45, 28* SCREEN_H_SP);
        }
        
        _cruxdrillUpButton.hidden = YES;
        [_cruxdrillUpButton setTitle:@"上钻" forState:UIControlStateNormal];
        _cruxdrillUpButton.layer.masksToBounds = YES;
        _cruxdrillUpButton.layer.cornerRadius = 5;
        [_cruxdrillUpButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
        _cruxdrillUpButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_cruxdrillUpButton addTarget:self action:@selector(cruxStroeDrillUpTounchButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_cruxdrillDownButton removeFromSuperview];
        _cruxdrillDownButton = nil;
        
        _cruxdrillDownButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _cruxdrillDownButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
        [bigview addSubview:_cruxdrillDownButton];
        _cruxdrillDownButton.hidden = YES;
        [_cruxdrillDownButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
        
        if (SCREEN_WIDTH == 320) {
            _cruxdrillDownButton.frame = CGRectMake(13 + SCREEN_WIDTH - 140 + 10 + 10 + 57, 70* SCREEN_H_SP, 40, 28*SCREEN_H_SP);
        }
        else if (SCREEN_WIDTH > 414){
            _cruxdrillDownButton.frame = CGRectMake(13 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 70* SCREEN_H_SP, 45, 28*SCREEN_H_SP);
        }
        else{
            _cruxdrillDownButton.frame = CGRectMake(13 + SCREEN_WIDTH - 140 + 10 + 10 + 51, 70* SCREEN_H_SP , 45, 28*SCREEN_H_SP);
        }
        
        [_cruxdrillDownButton setTitle:@"下钻" forState:UIControlStateNormal];
        _cruxdrillDownButton.layer.masksToBounds = YES;
        _cruxdrillDownButton.layer.cornerRadius = 5;
        _cruxdrillDownButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_cruxdrillDownButton addTarget:self action:@selector(cruxStroeDrillDownTounchButton) forControlEvents:UIControlEventTouchUpInside];

        
//        NSString * linchpinContentOffset = [[NSUserDefaults standardUserDefaults] objectForKey:@"linchpinContentOffsetX"];
//        if (linchpinContentOffset.length > 0) {
            bigview.ScrollView.contentOffset = CGPointMake(0, 0);
//        }
        
        [tableViews removeFromSuperview];
        tableViews = nil;
        
        tableViews = [[UITableView alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 110 * SCREEN_H_SP, SCREEN_WIDTH - 20 * SCREEN_W_SP,self.frame.size.height - 100 * SCREEN_H_SP - 64) style:UITableViewStylePlain];
        tableViews.dataSource = self;
        tableViews.delegate = self;
        tableViews.bounces = NO;
        tableViews.separatorStyle = NO;
        tableViews.tag = 15;
        tableViews.showsVerticalScrollIndicator = NO;
        tableViews.rowHeight = 260 * SCREEN_H_SP;
        [scrollView1 addSubview:tableViews];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
}

#pragma mark 点击上钻按钮
-(void)cruxStroeDrillUpTounchButton{
    
    _cruxDrill_type = @"1";
    
    if (_selectBagDic.count > 1) {
        [self refreshDatasWithCache:YES WithPiarry:_tempString WithCode:_Code];
    }
    else{
        [self refreshDatasWithCache:YES WithPiarry:s WithCode:_Code];
    }

}

#pragma mark 点击下钻按钮
-(void)cruxStroeDrillDownTounchButton{
    
    _cruxDrill_type = @"2";
    
    if (_selectBagDic.count > 1) {
        [self refreshDatasWithCache:YES WithPiarry:_tempString WithCode:_Code];
    }
    else{
        [self refreshDatasWithCache:YES WithPiarry:s WithCode:_Code];
    }

}

#pragma mark - UITableViewDataSource & UITabBarDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @try {
     
        return self.uptitArray.count;

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellForGuanJianCell"];
        
        @try {
            cell = [[TableViewCellForGuanJianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCellForGuanJianCell" WithArr1:(NSMutableArray *)self.values11[indexPath.row] WithArr2:(NSMutableArray *)self.values22[indexPath.row] WithArr3:(NSMutableArray *)_xValueArr];
        } @catch (NSException *exception) {
            DLog(@"IndexOutOfBound");
        } @finally {
            @try {
                cell.uplLab.text = _uptitArray[indexPath.row];
                cell.uprLab.text = _upNumArray[indexPath.row];
                cell.uprLab1.text = _upSignArray[indexPath.row];
            } @catch (NSException *exception) {
                DLog(@"IndexOutOfBound");
                
                cell.uplLab.text = @"";
                cell.uprLab.text = @"";
                cell.uprLab1.text = @"";
            } @finally {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        
        return cell;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 接口请求 主体
- (void)requestDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache WithPiarry:piarry WithCode:Code{
    
    @try {
        
#pragma mark  检查网络
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                NSString * dateString;
                if (_smailSelectIndex == 0) {
                    dateString = @"1";
                }
                else if (_smailSelectIndex == 1){
                    dateString = @"2";
                }
                else if (_smailSelectIndex == 2){
                    dateString = @"3";
                }
                else if (_smailSelectIndex == 3){
                    dateString = @"4";
                }
                
                NSDictionary * requestDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 [AppDatas sharedDatas].userCode, @"user_code",
                                                 Code, @"org_code",
                                                 piarry,@"pi_array",
                                                 fromDateStr, @"start_date",
                                                 toDateStr, @"end_date",dateString,@"time_level",_cruxDrill_type,@"drill_type",
                                                 nil];
                
                [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news2.KPIBoardBody"
                             dataParameters:requestDataDic
                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        
                dispatch_async(dispatch_get_main_queue(), ^{
                                            
                if ([responseDic[@"status"] isEqualToString:@"success"]) {
                    
                    
                [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                                
                self.dataDic2 = responseDic;
                   
                [animationView stopAnimating1];
                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                
                if ([_cruxDrill_type isEqualToString:@"1"] || [_cruxDrill_type isEqualToString:@"2"]) {
                    
                    if ([responseDic[@"data"][@"subheadSidebar"] count] == 0)
                    {
                        
                        [[HUDHelper getInstance] hideHUD];//隐藏提示框
                         _cruxDrill_type = @"0";
                        return;
                    }

                   [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"linchpinContentOffsetX"];
                    
                    [self.delegate transMitheadTitle:self.dataDic2[@"data"][@"subheadSidebar"][0][@"code"] nameString:self.dataDic2[@"data"][@"subheadSidebar"][0][@"name"]];
                    
                    _bigSelectIndex = 0;
                    [self createUI];
                
                }
                                                
            
               if (firstCreate == 1) {
                                                    
                    [self createUI];
                                                    
                    firstCreate = 2;
               }
                                                
              [self refreshDatasAndViews];
                                                
              }
            else{
                            
                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                        
            }
                    
            _cruxDrill_type = @"0";
                    
            });
            
           }
           failure:^(NSError *error) {
                                        
                dispatch_async(dispatch_get_main_queue(), ^{
                                
                    _cruxDrill_type = @"0";
                    
                    [animationView stopAnimating1];
                    
                    scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                            
                   if (error.code == -1001) {
                                                
                    [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
                                                
                   }else{
                                                
                    [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                    }
                        
                    });
                }];
            });
        }
        else{
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 请求成功后刷新数据和页面
-(void)refreshDatasAndViews{
    
    @try {
        
        if ([self.dataDic2[@"data"][@"sortList"] count] == 0) {
            return;
        }
        
        if (self.dataDic2){
            
            NSArray *arr;
            if (_smailSelectIndex == 0) {
                if (_bigSelectIndex <= [self.dataDic2[@"data"][@"sortList"] count] -1){
                    
                    arr = self.dataDic2[@"data"][@"sortList"][_bigSelectIndex][@"dataDay"];
                }
                else{
                    
                    arr = self.dataDic2[@"data"][@"sortList"][[self.dataDic2[@"data"][@"sortList"] count] -1][@"dataDay"];
                }
                
            } else if (_smailSelectIndex == 1) {
                
                if (_bigSelectIndex <= [self.dataDic2[@"data"][@"sortList"] count] -1){
                    
                    arr = self.dataDic2[@"data"][@"sortList"][_bigSelectIndex][@"dataWeek"];
                }
                else{
                  
                    arr = self.dataDic2[@"data"][@"sortList"][[self.dataDic2[@"data"][@"sortList"] count] -1][@"dataWeek"];
                }
                
            } else if (_smailSelectIndex == 2) {
                
                if (_bigSelectIndex <= [self.dataDic2[@"data"][@"sortList"] count] -1){
                    
                    arr = self.dataDic2[@"data"][@"sortList"][_bigSelectIndex][@"dataMonth"];
                }
                else{
                 
                    arr = self.dataDic2[@"data"][@"sortList"][[self.dataDic2[@"data"][@"sortList"] count] -1][@"dataMonth"];
                }
                
            } else if (_smailSelectIndex == 3) {
                
                if (_bigSelectIndex <=  [self.dataDic2[@"data"][@"sortList"] count] -1){
                    
                    arr = self.dataDic2[@"data"][@"sortList"][_bigSelectIndex][@"dataYear"];
                }
                else{
                    
                    arr = self.dataDic2[@"data"][@"sortList"][[self.dataDic2[@"data"][@"sortList"] count] -1][@"dataYear"];
                }
                
            }
            
            _upNumArray = nil;
            _upNumArray = [NSMutableArray new];
            NSString * valueStr;
            
            for (int i = 0; i< arr.count; i++) {
                
                NSArray * arr1 = arr[i][@"chartList"];
                
                valueStr = arr1[arr1.count - 1][@"value"];
                
                [_upNumArray addObject:valueStr];
                
            }
            
            _values11 = nil;
            _values22 = nil;
            
            _values11 = [NSMutableArray new];
            _values22 = [NSMutableArray new];
            
            NSString *valueT;
            NSString *xAxisT;
            
            for (int i = 0; i< arr.count; i++) {
                
                NSMutableArray  * values1 = [NSMutableArray new];
                NSMutableArray  *  values2 = [NSMutableArray new];
                
                _xValueArr = [NSMutableArray new];
                _xValueArr = arr[i][@"chartList"];
                
                for (int j = 0; j < _xValueArr.count; j++) {
                    
                    valueT = _xValueArr[j][@"value"];
                    xAxisT = _xValueArr[j][@"xAxis"];
                    
                    [values1 addObject:valueT];
                    [values2 addObject:xAxisT];
                    
                }
                
                [_values11 insertObject: values1 atIndex:i];
                [_values22 insertObject:values2 atIndex:i];
                
            }
            
        }
        
        [tableViews reloadData];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
    
}

#pragma mark - subheadBar 切换
- (void)headBarView:(BigAndTimeView *)bigAndTimeView index:(NSInteger)index{
    
    @try {
     
        for (NSInteger i = 0; i < bigview.array.count; i ++) {
            UIButton * button = bigview.array[i];
            
            button.selected = NO;
        }
        
        if (index > 0) {
         
        for (NSInteger w = 0; w < bigview.downArr.count; w++) {
            
            UIButton * button = bigview.downArr[w];
                
            button.frame = CGRectMake((SCREEN_WIDTH / ([bigview.downArr count] + 1) -10) * w + 10, 70* SCREEN_H_SP, SCREEN_WIDTH / ([bigview.downArr count] + 1) - 20* SCREEN_W_SP, 28* SCREEN_H_SP);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
          }
            
            _cruxdrillUpButton.hidden = NO;
            _cruxdrillDownButton.hidden = NO;

        }
        else if(index == 0){
        
        for (NSInteger w = 0; w < bigview.downArr.count; w++) {
                
                UIButton * button = bigview.downArr[w];
                
                button.frame = CGRectMake(SCREEN_WIDTH / [bigview.downArr count] * w + 10* SCREEN_W_SP, 70* SCREEN_H_SP, SCREEN_WIDTH /[bigview.downArr count] - 20* SCREEN_W_SP, 30* SCREEN_H_SP);
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            }
            
            _cruxdrillUpButton.hidden = YES;
            _cruxdrillDownButton.hidden = YES;
        }

        UIButton * button = bigview.array[index];
        button.selected = YES;
        
        _bigSelectIndex = index;
        
        _Code  = _codeArray[_bigSelectIndex];
        
        if (_selectBagDic.count > 1) {
            [self refreshDatasWithCache:YES WithPiarry:_tempString WithCode:_Code];
        }
        else{
            [self refreshDatasWithCache:YES WithPiarry:s WithCode:_Code];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
}

#pragma mark - 切换日周月年
- (void)bigAndTimeView:(BigAndTimeView *)bigAndTimeView index:(NSInteger)index{
    
    @try {
      
        _smailSelectIndex = index;
        
        if (_selectBagDic.count > 1) {
            [self refreshDatasWithCache:YES WithPiarry:_tempString WithCode:_Code];
        }
        else{
            [self refreshDatasWithCache:YES WithPiarry:s WithCode:_Code];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
  //  [self refreshDatasAndViews];

}

#pragma mark - 回调
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    @try {
        
        [animationView startAnimation];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
   // else if(scrollView.contentOffset.y > SCREEN_HEIGHT - 120){
  //      scrollView1.bounces = NO;
  //  }

    @try {
        
        if (scrollView.contentOffset.y <= -80) {
            
            if (animationView.tag == 0) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    
                    //                  [animationView startAnimation];
                    
                });
                
            }
            
            animationView.tag = 1;
            
        }else{
            
            //防止用户在下拉到contentOffset.y <= -50后不松手，然后又往回滑动，需要将值设为默认状态
            
            animationView.tag = 0;
            
            if (tableViews.tag == 15) {
                
                if (tableViews.contentOffset.y > 100) {
                    scrollView1.bounces = NO;
                }
                else{
                    scrollView1.bounces = YES;
                }
            }
            
        }
 
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 即将结束拖拽

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    @try {
        
        [animationView stopAnimating];
        
        
        if (scrollView.contentOffset.y <= -80) {
            
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        }
        
        if (animationView.tag == 1) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                scrollView1.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                
                [animationView startAnimation1];
                
                if (_selectBagDic.count > 1) {
                    [self refreshDatasWithCache:YES WithPiarry:_tempString WithCode:_Code];
                }
                else{
                    [self refreshDatasWithCache:YES WithPiarry:s WithCode:_Code];
                }
                
                
                //            self.refresh.text = @"加载中";
                
            }];
            
            //数据加载成功后执行；这里为了模拟加载效果，一秒后执行恢复原状代码
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:.3 animations:^{
                    
                    animationView.tag = 0;
                    
                    
                    
                }];
                
            });
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


@end
