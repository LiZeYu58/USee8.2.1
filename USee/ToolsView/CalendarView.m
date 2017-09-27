//
//  CalendarView.m
//  LOSBi
//
//  Created by JJT on 16/8/15.
//  Copyright © 2016年 L.O.S. All rights reserved.



//       日历控件




#import "CalendarView.h"
#import "YearsCollectionViewCell.h"
#import "NSDate+Escort.h"
#import "NSDate+Formatter.h"
#import "LeftSlideViewController.h"
#import "NSDate+LOSCompare.h"
#import "AppDatas.h"
#import "AppDelegate.h"


#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define Iphone6Scale(x) ((x) * LL_SCREEN_WIDTH / 375.0f)
#define HeaderViewHeight 30
#define WeekViewHeight 40


@interface CalendarView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

{
    
    CalendarCell *cell1;
    
    //    NSInteger remarkDateIndex;
    
}

@property (nonatomic,strong)UICollectionView * yearCollectView;
@property (nonatomic,strong) NSArray * yearDateArray;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIButton * leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong)UIView *line2;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dayModelArray;
@property (strong, nonatomic) NSDate *tempDate;
@property (assign, nonatomic) NSInteger month;
@property (strong, nonatomic) NSDate *rushDate;
@property (nonatomic,strong) UIView *line3;

@property (nonatomic, strong) MonthModel *selectedMonthModel;
@property (nonatomic, strong) NSDate * getDate;

@property (nonatomic, assign) NSInteger selectionYear;
@property (nonatomic, assign) NSInteger selectionMonth;
@property (nonatomic, assign) NSInteger selectionDate;

@end
@implementation CalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self showCalendar];
    }
    return self;
}

#pragma mark - 左按钮 展示1-6月
-(UIButton *)leftBtn{
    if (!_leftBtn) {
        self.leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.leftBtn setImage:[UIImage imageNamed:@"arrow_white_left"] forState:UIControlStateNormal];
        [self.leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

#pragma mark - 左按钮 展示7-12月
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        self.rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.rightBtn setImage:[UIImage imageNamed:@"arrow_white_right"] forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}



-(UIScrollView *)scrollView{
    NSArray *title = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 40 * SCREEN_W_SP);
        self.scrollView.delegate = self;
        self.scrollView.scrollEnabled = NO;
        self.scrollView.pagingEnabled =YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        
        NSDate *initDate = [AppDatas sharedDatas].selectFromDate;
        _month = initDate.month;
        
        for (int i=1; i<13; i++) {
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 80 * SCREEN_W_SP) / 6 * (i-1),0, (SCREEN_WIDTH - 80 * SCREEN_W_SP) / 6 , 40 * SCREEN_W_SP)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHex:0xeb4b55] forState:UIControlStateSelected];
            [btn setTitle:title[(i-1)] forState:UIControlStateNormal];
            btn.tag=i;
            if (_month == btn.tag) {
                btn.selected = YES;
                
                if (_month <= 6) {
                    [self.scrollView setContentOffset:CGPointMake(0, 0)animated:YES];
                }if (_month > 6) {
                    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH - 80 * SCREEN_W_SP, 0)animated:YES];
                }
            }
            [btn addTarget:self action:@selector(btn_Click:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:btn];
        }
    }
    return _scrollView;
}

- (NSArray *)yearDateArray {
    if (_yearDateArray == nil) {
        
        self.yearDateArray =  @[@"2000",@"2001",@"2002",@"2003",@"2004",@"2005",@"2006",@"2007",@"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030"];
        
    }
    return _yearDateArray;
}

-(UICollectionView *)yearCollectView{
    
    if (!_yearCollectView) {
        
        UICollectionViewFlowLayout *flowlayout=[[UICollectionViewFlowLayout alloc] init];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowlayout.minimumInteritemSpacing = 0;
        flowlayout.minimumLineSpacing = 0;
        flowlayout.itemSize = CGSizeMake(SCREEN_WIDTH / 3, 50);
        
        self.yearCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        self.yearCollectView.backgroundColor = [UIColor clearColor];
        self.yearCollectView.delegate = self;
        self.yearCollectView.dataSource = self;
        self.yearCollectView.showsHorizontalScrollIndicator = NO;
        [self.yearCollectView registerClass:[YearsCollectionViewCell class]forCellWithReuseIdentifier:@"collection"];
        
    }
    
    return _yearCollectView;
    
}


- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        NSInteger width = Iphone6Scale(54);
        NSInteger height = Iphone6Scale(54);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.headerReferenceSize = CGSizeMake(LL_SCREEN_WIDTH, HeaderViewHeight);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
        [_collectionView registerClass:[CalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalendarHeaderView"];
        
    }
    
    return _collectionView;
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.yearCollectView) {
        
        return self.yearDateArray.count;
        
    }else{
        
        return  self.dayModelArray.count;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.yearCollectView) {
        
        YearsCollectionViewCell *cell;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
        cell.yearLab.text = self.yearDateArray[indexPath.row];
        
        if (_selectionYear == [self.yearDateArray[indexPath.row] intValue]) {
            
            [self.yearCollectView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            
            cell.yearLab.textColor = [UIColor colorWithHex: 0xeb4b55];
            
        }else{
            
            cell.yearLab.textColor = [UIColor whiteColor];
            
        }
        
        return cell;
        
    } else if (collectionView == self.collectionView){
        
        CalendarCell *cell;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
        cell.dayLabel.backgroundColor = [UIColor whiteColor];
        cell.dayLabel.textColor = [UIColor blackColor];
        id mon = self.dayModelArray[indexPath.row];
        
        if ([mon isKindOfClass:[MonthModel class]]) {
            
            cell.monthModel = (MonthModel *)mon;
            cell.userInteractionEnabled = YES;
            
            
        }else{
            
            cell.dayLabel.text = @"";
            cell.dayLabel.backgroundColor = [UIColor clearColor];
            cell.userInteractionEnabled = NO;
            cell.lab.text = @"";		
            
        }
        
        if (_selectionYear == [[AppDatas sharedDatas].positionYear integerValue] && _selectionMonth == [[AppDatas sharedDatas].positionMonth integerValue] && indexPath.row == [[AppDatas sharedDatas].positionDate integerValue]) {
            
           
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            
            cell.img.image = [UIImage imageNamed:@"img_日历选中"];

            if (cell.lab.text.length > 0) {
                
                cell.img.frame =  CGRectMake(5, 8, cell.contentView.frame.size.width -10, cell.contentView.frame.size.height -10);
            }
            
        } else {
            
            cell.img.image = nil;
            
        }
        
        return cell;
        
    } else {
        
        return nil;
        
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        
        CalendarCell *cell = (CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.img.image = nil;
        
    } else if (collectionView == self.yearCollectView) {
        
        YearsCollectionViewCell *cell = (YearsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.yearLab.textColor = [UIColor whiteColor];
        
    }
    
}

#pragma mark - 选择某个单元格时回调此函数
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
        
        id mon = self.dayModelArray[indexPath.row];
        
        if ([mon isKindOfClass:[MonthModel class]]) {
            self.getDate = [(MonthModel *)mon dateValue];
            NSInteger currentYear = [[NSDate date] year];
            NSInteger currentMonth = [[NSDate date] month];
            NSInteger currentDay = [[NSDate date] day];
            
            if (self.getDate.year == currentYear && self.getDate.month == currentMonth && self.getDate.day > currentDay) {
                
                [collectionView reloadData];
                return;
                
            }
            
            [self didSelectedDate:self.getDate];
            
        }
        
        [AppDatas sharedDatas].positionDate = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        [AppDatas sharedDatas].positionMonth = [NSString stringWithFormat:@"%ld", (long)_selectionMonth];
        [AppDatas sharedDatas].positionYear = [NSString stringWithFormat:@"%ld", (long)_selectionYear];
        
        CalendarCell *cell = (CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.img.image = [UIImage imageNamed:@"img_日历选中"];
        _selectionDate = [cell.lab.text integerValue];
        self.selectedMonthModel = cell.monthModel;
        
    } else if (collectionView == self.yearCollectView) {
        
        if (_selectionYear == [self.yearDateArray[indexPath.row] intValue]) {
            
            return;
            
        }
        
        NSInteger currentYear = [[NSDate date] year];
        
        if ([self.yearDateArray[indexPath.row] integerValue] > currentYear) {
            
            [collectionView reloadData];
            return;
            
        }
        
        YearsCollectionViewCell *cell = (YearsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.yearLab.textColor = [UIColor colorWithHex: 0xeb4b55];
        
        _selectionYear = [cell.yearLab.text intValue];
        
        self.rushDate = [self dateOfYear:_selectionYear WithMonth:_selectionMonth];
        
        [self calendarInit:_rushDate];
    }
}

-(void)reloadData{
    
    [self.yearCollectView reloadData];
    
    [self.collectionView reloadData];
    
}


#pragma mark - 选中日期
- (void)didSelectedDate:(NSDate *)inDate {
    //    DAlert(@"didSelectedDate");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationForSelectDate object:@{@"fromDate":inDate, @"toDate":inDate}];
}


-(void)showCalendar{
    
    self.yearCollectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44 * SCREEN_H_SP);
    [self addSubview:self.yearCollectView];
    
    self.line1 = [[UIView alloc]initWithFrame:CGRectMake(10,44 * SCREEN_H_SP, SCREEN_WIDTH - 20, 1)];
    self.line1.backgroundColor = [UIColor colorWithHex:0x613b3b];
    [self addSubview:self.line1];
    
    self.leftBtn.frame = CGRectMake(0, self.line1.frame.origin.y , 30, 40* SCREEN_H_SP);
    [self addSubview:self.leftBtn];
    
    self.scrollView.frame = CGRectMake(40* SCREEN_H_SP, self.line1.frame.origin.y, SCREEN_WIDTH - 80* SCREEN_W_SP, 40* SCREEN_H_SP);
    [self addSubview:self.scrollView];
    
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - 30, self.line1.frame.origin.y, 30, 40* SCREEN_H_SP);
    [self addSubview:self.rightBtn];
    
    self.line2 = [[UIView alloc]initWithFrame:CGRectMake(10, self.scrollView.frame.origin.y + 40* SCREEN_H_SP, SCREEN_WIDTH - 20, 1)];
    self.line2.backgroundColor = [UIColor colorWithHex:0x613b3b];
    [self addSubview:self.line2];
    
    NSInteger width = Iphone6Scale(54);
    self.collectionView.frame = CGRectMake(0, self.line2.frame.origin.y, width * 7, SCREEN_H_SP * 360);
    [self addSubview:self.collectionView];
    
    self.line3 =[[ UIView alloc]initWithFrame:CGRectMake(10, self.collectionView.frame.origin.y + SCREEN_H_SP * 360, SCREEN_WIDTH - 20, 1)];
    self.line3.backgroundColor = [UIColor colorWithHex:0x613b3b];
    [self addSubview:self.line3];
    
    UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CalanderHandle"]];
    [imgView setCenter:CGPointMake(SCREEN_WIDTH / 2, self.line3.frame.origin.y + 24 * SCREEN_H_SP)];
    [self addSubview:imgView];
    
    
    NSInteger ddd= [AppDatas sharedDatas].selectFromDate.year;
    
    [self.yearCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:ddd - 2000 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
}



-(void)leftBtn:(UIButton *)sender{
    
    if (self.scrollView.contentOffset.x > 0) {
        
        [self.scrollView setContentOffset:CGPointMake(0, 0)animated:YES];
        
    }
    
}

-(void)rightBtn:(UIButton *)sender{
    
    if (self.scrollView.contentOffset.x == 0) {
        
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH - 80 * SCREEN_W_SP, 0)animated:YES];
        
    }
    
}

-(void)btn_Click:(UIButton *)sender{
    
    NSInteger num = sender.tag;
    NSInteger currentYear = [[NSDate date] year];
    NSInteger currentMonth = [[NSDate date] month];
    
    if (_selectionYear == currentYear && num > currentMonth) {
        return;
    }
    
    for (int i = 1; i< 13; i++) {
        
        UIButton *btn=(UIButton *)[self viewWithTag:i];
        btn.selected = NO;
        
    }
    
    UIButton *btn=(UIButton *)[self viewWithTag:num];
    btn.selected=YES;
    
    _selectionMonth = sender.tag;
    
    self.rushDate = [self dateOfYear:_selectionYear WithMonth:_selectionMonth];
    
    [self calendarInit:self.rushDate];
    
}

- (void)calendarInit:(NSDate *)date{
    
    NSInteger year = [date year];
    NSInteger month = [date month];
    NSInteger days = [self numberOfDaysInMonth:date];
    
    _selectionYear = [date year];
    _selectionMonth = month;
    _selectionDate = [AppDatas sharedDatas].selectFromDate.day;
    
    NSInteger week = [self startDayOfWeek:date];
    self.dayModelArray = [[NSMutableArray alloc] initWithCapacity:42];
    int day = 1;
    
    for (int i= 1; i<days+week; i++) {
        
        if (i<week) {
            
            [self.dayModelArray addObject:@""];
            
        }else{
            
            MonthModel *mon = [MonthModel new];
            mon.dayValue = day;
            NSDate *dayDate = [NSDate dateWithYear:year month:month day:day];
            mon.dateValue = dayDate;
            
            if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate date].yyyyMMddByLineWithDate]) {
                
                mon.isSelectedDay = YES;
                
            }
            
            if(_selectionDate == day){
                
                [AppDatas sharedDatas].positionDate = [NSString stringWithFormat:@"%d", i - 1 ];
                
            }
            
            [self.dayModelArray addObject:mon];
            
            day++;
            
        }
        
    }
    
    [self.collectionView reloadData];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    CalendarHeaderView *headerView;
    
    if (self.collectionView) {
        
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalendarHeaderView" forIndexPath:indexPath];
        
    }
    
    return headerView;
    
}


#pragma mark -Private
- (NSUInteger)numberOfDaysInMonth:(NSDate *)date{
    
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    return [greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    
}

- (NSDate *)firstDateOfMonth:(NSDate *)date{
    
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:date];
    
    comps.day = 1;
    
    return [greCalendar dateFromComponents:comps];
    
}

- (NSUInteger)startDayOfWeek:(NSDate *)date{
    
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:[self firstDateOfMonth:date]];
    
    return comps.weekday;
    
}

- (NSDate *)dateOfDay:(NSInteger)day{
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:[NSDate date]];
    
    comps.day = day;
    
    return [greCalendar dateFromComponents:comps];
    
}

- (NSDate *)dateOfYear:(NSInteger)year WithMonth:(NSInteger)month{
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth
                               fromDate:[NSDate date]];
    
    comps.year = year;
    comps.month = month;
    
    return [greCalendar dateFromComponents:comps];
    
}


@end

@implementation CalendarHeaderView - (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *weekArray = [[NSArray alloc] initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
        
        for (int i=0; i<weekArray.count; i++) {
            
            UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*Iphone6Scale(54), 0, Iphone6Scale(54), HeaderViewHeight)];
            
            weekLabel.textAlignment = NSTextAlignmentCenter;
            weekLabel.textColor = [UIColor colorWithHex:0x6d6264];
            weekLabel.font = [UIFont systemFontOfSize:17.f];
            weekLabel.text = weekArray[i];
            
            [self addSubview:weekLabel];
            
        }
        
    }
    
    return self;
    
}


@end

#pragma mark - day cell

@implementation CalendarCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        CGFloat width = self.contentView.frame.size.width*0.6;
        CGFloat height = self.contentView.frame.size.height*0.6;
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.contentView.frame.size.width*0.5-width*0.5,  self.contentView.frame.size.height*0.5-height*0.5, width, height )];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.layer.masksToBounds = YES;
        dayLabel.layer.cornerRadius = height * 0.5;
        [self.contentView addSubview:dayLabel];
        self.dayLabel = dayLabel;
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, dayLabel.frame.origin.y + dayLabel.frame.size.height - 5, self.contentView.frame.size.width, 10)];
        lab.font = [UIFont systemFontOfSize:10];
        lab.textColor = [UIColor colorWithHex:0xeb4b55];
        lab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lab];
        self.lab = lab;
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.contentView.frame.size.width -10, self.contentView.frame.size.height -10)];
        [self.contentView addSubview:img];
        self.img = img;
        
    }
    
    return self;
    
}

- (void)setMonthModel:(MonthModel *)monthModel{
    
    _monthModel = monthModel;
    self.dayLabel.text = [NSString stringWithFormat:@"%02ld",(long)monthModel.dayValue];
    self.dayLabel.textColor = [UIColor whiteColor];
    self.dayLabel.backgroundColor = [UIColor clearColor];
    self.lab.text = @"";
    
    if (monthModel.isSelectedDay) {
        
        self.lab.text = @"今天";
        
    }
}


@end

@implementation MonthModel

@end


