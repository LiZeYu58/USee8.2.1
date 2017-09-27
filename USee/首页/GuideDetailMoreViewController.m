//
//  GuideDetailMoreViewController.m
//  LOSBi
//
//  Created by JJT on 16/11/10.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "GuideDetailMoreViewController.h"
#import "AppDelegate.h"
#import "AppDatas.h"
#import "ShowView.h"
#import "GuideDetailMoreViewCell1.h"
#import "GuideDetailMoreViewCell2.h"
#import "UICollectionHeaderView.h"
#import "UICollectionFooterView.h"
#import "AnimationView.h"
#import "ShareMenuViewController.h"
#import "LOSHelper.h"

@interface GuideDetailMoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    
    UIButton *titleBtn; //标题
    UIButton * calendarBtn; // 日历按钮
    ShowView *sv; // 日历展示
    UICollectionView * collectView; //数据展示的collectView
    UIScrollView * scrollView1; //整体下拉刷新的滚动试图
    AnimationView * animationView; //下拉刷新的动画
    
}

@end

@implementation GuideDetailMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];

    self.view.backgroundColor = [UIColor colorWithHex:0xe4e4e4];
    
    titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, 0, 100, 44)];
    [titleBtn setTitle:self.dimName forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.navigationItem.titleView = titleBtn;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:0xba2932];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 44);
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(0, 0, 44, 44);
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *rightBtn1 = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];

    calendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarBtn setBackgroundImage:[UIImage imageNamed:@"bg_calendar"] forState:UIControlStateNormal];
    calendarBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM dd"];
    NSString * currentDateString = [dateFormatter stringFromDate:[AppDatas sharedDatas].selectFromDate];
    NSString * toDateString = [dateFormatter stringFromDate:[AppDatas sharedDatas].selectToDate];
    if ([currentDateString isEqualToString:toDateString]) {
        
        [calendarBtn setTitle:currentDateString forState:UIControlStateNormal];
    }else{
        
        [calendarBtn setTitle:@"时 段" forState:UIControlStateNormal];
    }
    calendarBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);//文字下移
    calendarBtn.frame = CGRectMake(0, 0, 44, 44);
    [calendarBtn addTarget:self action:@selector(calendarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightBtnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    [rightBtnsView addSubview:shareBtn];
    [rightBtnsView addSubview:calendarBtn];
    calendarBtn.x = 5;
    shareBtn.x = 49;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtnsView];
    
    sv = [[ShowView alloc]initWithFrame:self.view.bounds];
    [sv CreateView];
    [self.view addSubview:sv];

    [self createUI];
  
}


-(void)createUI{
    
    [scrollView1 removeFromSuperview];
    scrollView1 = nil;
    
    scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height)];
    scrollView1.delegate =self;
    scrollView1.showsVerticalScrollIndicator = NO;
    scrollView1.contentSize = CGSizeMake(0, self.view.height + 80 * SCREEN_H_SP);
    scrollView1.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView1];
    
    animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 100)];
    animationView.layer.borderColor = [UIColor redColor].CGColor;
    [animationView Animation];
    [animationView Animation1];
    [scrollView1 addSubview:animationView];
    
    UICollectionViewFlowLayout *flowlayout=[[UICollectionViewFlowLayout alloc] init];
    flowlayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(5 * SCREEN_W_SP, 64, SCREEN_WIDTH - 10 * SCREEN_W_SP, self.view.height) collectionViewLayout:flowlayout];
    collectView.backgroundColor=[UIColor colorWithHex:0xe4e4e4];
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.scrollEnabled = NO;
    [collectView registerClass:[GuideDetailMoreViewCell1 class] forCellWithReuseIdentifier:@"collection1"];
    [collectView registerClass:[GuideDetailMoreViewCell2 class] forCellWithReuseIdentifier:@"collection2"];
    [collectView registerClass:[UICollectionHeaderView
 class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionHeaderView"];

    [collectView registerClass:[UICollectionFooterView
 class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionFooterView"];
    
    [scrollView1 addSubview:collectView];

}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 3;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return 4;
        
    }else
        
        return 6;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GuideDetailMoreViewCell1 *cell1=[collectionView dequeueReusableCellWithReuseIdentifier:@"collection1" forIndexPath:indexPath];
    
    
    GuideDetailMoreViewCell2 *cell2=[collectionView dequeueReusableCellWithReuseIdentifier:@"collection2" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        
        if (indexPath.row == 2 || indexPath.row == 5) {
            
            cell1.lineView.backgroundColor = [UIColor whiteColor];
        }else{
            
            
            cell1.lineView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
            
        }
        
    }
    
    if (indexPath.section == 1) {
        
        
        if (indexPath.row == 3) {
            
            cell2.lineView.backgroundColor = [UIColor whiteColor];
        }else{
            
            
            cell2.lineView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
            
        }
        
        
        return cell2;
        
    }

    
    if (indexPath.section == 2) {
        
        
        if (indexPath.row == 2 || indexPath.row == 5) {
            
            cell1.lineView.backgroundColor = [UIColor whiteColor];
        }else{
            
            
            cell1.lineView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
            
        }
        
    }

    return cell1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
         return CGSizeMake((SCREEN_WIDTH - 10 * SCREEN_W_SP) / 4 , 95 * SCREEN_H_SP);
        
    }else{
    
    return CGSizeMake((SCREEN_WIDTH - 10 * SCREEN_W_SP) / 3 , 95 * SCREEN_H_SP);
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return CGSizeMake(SCREEN_WIDTH - 10 * SCREEN_W_SP , 88 * SCREEN_H_SP);

        
    }else{
    
    
    return CGSizeMake(SCREEN_WIDTH - 10 * SCREEN_W_SP , 44 * SCREEN_H_SP);
        
    }
    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    
     return CGSizeMake(SCREEN_WIDTH - 10 * SCREEN_W_SP , 10 * SCREEN_H_SP);
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionHeader ]){
        reuseIdentifier = @"UICollectionHeaderView";
    }
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = @"UICollectionFooterView";
    }
    
    UICollectionHeaderView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
     UICollectionFooterView *view1 =  [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    view.backgroundColor = [UIColor colorWithHex:0xba2932];
    
    if (indexPath.section == 0) {
        
        
        UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 10 * SCREEN_W_SP, 44 * SCREEN_H_SP)];
        
        topView.backgroundColor = [UIColor colorWithHex:0xe4e4e4];

        [view addSubview:topView];
        
        
        UILabel * onLineTimes = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180 * SCREEN_W_SP, 44 * SCREEN_H_SP)];
        
        onLineTimes.text = @"你哈似的";
        
        onLineTimes.textColor = [UIColor grayColor];
        
        onLineTimes.font = [UIFont systemFontOfSize:13];
        
        [view addSubview:onLineTimes];
        
        
        UILabel * storeName = [[UILabel alloc]initWithFrame:CGRectMake(topView.frame.size.width - 120 * SCREEN_W_SP, 0, 120 * SCREEN_W_SP, 44 * SCREEN_H_SP)];
        
        storeName.text = @"王府井旗舰店";
        
        storeName.textAlignment = NSTextAlignmentRight;
        
        storeName.textColor = [UIColor grayColor];
        
        storeName.font = [UIFont systemFontOfSize:13];
        
        [view addSubview:storeName];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, topView.frame.size.height, 160, 44 * SCREEN_H_SP)];
        
        label.font = [UIFont systemFontOfSize:14];
        
        label.textColor = [UIColor whiteColor];
        
        [view addSubview:label];
        
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
            label.text = [NSString stringWithFormat:@"这是header:%ld",(long)indexPath.section];
        }
        
        else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
            view1.backgroundColor = [UIColor colorWithHex:0xe4e4e4];
        }
        
    }else{
        
        UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 10 * SCREEN_W_SP, 0.01)];
        
        topView.backgroundColor = [UIColor colorWithHex:0xe4e4e4];

        [view addSubview:topView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, topView.frame.size.height, 160, 44 * SCREEN_H_SP)];
    
         label.font = [UIFont systemFontOfSize:14];
        
         label.textColor = [UIColor whiteColor];
    
         [view addSubview:label];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
         label.text = [NSString stringWithFormat:@"这是header:%ld",(long)indexPath.section];
    }
        
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
         view1.backgroundColor = [UIColor colorWithHex:0xe4e4e4];
    }

        
    }
        return view;
}


#pragma mark -  返回按钮
-(void)leftBarBtnClicked{
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [tempAppDelegate.mainNavigationController popViewControllerAnimated:YES];
    
}

- (void)shareBtnClicked:(UIButton *)sender {
        ShareMenuViewController *smvc = [[ShareMenuViewController alloc] initWithShareBtn:sender];
    
//        smvc.vi = [LOSHelper getSnapshotImage];

    
        [self presentViewController:smvc animated:YES completion:^{
    
        }];
}

#pragma mark -  点击导航栏上日历按钮
-(void)calendarBtnClick{
    
    calendarBtn.selected = !calendarBtn.selected;
    if (calendarBtn.selected) {
        
        //[self hehe];
        [sv showView];
    }if (!calendarBtn.selected) {
        [sv backView];
    }
}

//scrollView 回调
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [animationView startAnimation];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y <= -80) {
        
        if (animationView.tag == 0) {
 
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            });

        }
        
        animationView.tag = 1;
        
    }else{
        
        animationView.tag = 0;
        
    }
    
}


//即将结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    [animationView stopAnimating];
    
    if (scrollView.contentOffset.y <= -80) {
        
       // [_alert alterShow];
        
    }
    
    if (animationView.tag == 1) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [animationView startAnimation1];
            
           // [self refreshDatasWithCache:YES WithPiarry:s WithCode:_Code];
            
            scrollView1.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:.3 animations:^{
                
                animationView.tag = 0;
                
            }];
            
        });
        
    }
    
}




@end
