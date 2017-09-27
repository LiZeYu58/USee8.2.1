//
//  SheQuView.m
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.





    // 社区 （二级页面）




#import "SheQuView.h"
#import "AppDatas.h"
#import "AppDelegate.h"
#import  <WebKit/WebKit.h>

#import "UIButton+LOSButton.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVPlayer.h>

@interface SheQuView()<UIWebViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIScrollViewDelegate,WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>
{
    
    UIWebView *localWebView;
    
    WKWebView *localWKWebView;
    
    NSString *_imageUrl;
    UIActivityIndicatorView *activity;
    UIView *loadProgressView;
   
    NSString *currentURL;
   
    UIButton *closeBtn;
    NSString *urlStr;
    NSString *returnData;
    
    NSInteger _tabrbarIntger;
    
    TwoAnimationView * twoAnimationView;
}

@end

@implementation SheQuView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {


        
    }
    
    return self;
}


-(void)SheQuTableBarClick:(NSNotification *)notif{

    //载入webView
    [self createUI];
    
}

-(void)receiveCode:(NSString *)orgCode{
    
    @try {
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
        [[NSURLCache sharedURLCache]removeAllCachedResponses];
        //状态栏字体颜色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        _tabrbarIntger = 1;
        [self setUserInfoData];
        
        [self createUI];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)setUserInfoData {
    
    @try {
        NSMutableDictionary *user_info = [CommonTools readFile:@"user_info.plist"];
        NSString *corp_code = user_info[@"corp_code"];
        NSString *company_name = user_info[@"company_name"];
        NSString *phone = user_info[@"phone"];
        NSString *sex = user_info[@"sex"];
        NSString *user_id = user_info[@"user_id"];
        NSString *user_name = user_info[@"user_name"];
        NSString *user_tag = user_info[@"user_tag"];
        NSString *avatar = user_info[@"avatar"];
        
        
        NSMutableDictionary *returnDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                          corp_code,@"corp_code",
                                          company_name,@"company_name",
                                          phone,@"phone",
                                          sex,@"sex",
                                          user_id,@"user_id",
                                          user_name,@"user_name",
                                          user_tag,@"user_tag", nil];
        if ([CommonTools checkUrlSrting:avatar]) {
            [returnDic setValue:avatar forKey:@"avatar"];
        }
        returnData = [CommonTools dictionaryToJson:(NSDictionary *)returnDic];

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)createUI{
    
        
        self.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue >= 8.0) {
            // 针对 8.0 以上的iOS系统进行处理
        [self creatWebView];
        //  [self creatWKWebView];
            
        } else {
            
            [self creatWebView];
            
        }
}

-(void)creatWebView{
    
    [localWebView removeFromSuperview];
    localWebView = nil;
    
    if (!localWebView) {
        
        if (SCREEN_HEIGHT == 812) {
            localWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -57, SCREEN_WIDTH, SCREEN_HEIGHT -  0 - 50 * SCREEN_H_SP + 20)];
            
          [self addSubview:localWebView];
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
            view.backgroundColor = [UIColor colorWithHex:0xb3333a];
            
            [self addSubview: view];
        }
        else{
            localWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT -  0 - 50 * SCREEN_H_SP + 20)];
            
            [self addSubview:localWebView];
        }
        
        UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        longPressed.delegate = self;
        [localWebView addGestureRecognizer:longPressed];
        
        localWebView.delegate = self;
        localWebView.scrollView.delegate = self;
        // [localWebView.scrollView addHeaderWithTarget:self action:@selector(headEndRefresh)];
        localWebView.backgroundColor = [UIColor clearColor];
        [localWebView setScalesPageToFit:YES];
        NSURL *url = [[NSURL alloc]initWithString:formalSheQu_Html5];
        [localWebView loadRequest:[NSURLRequest requestWithURL:url]];
        localWebView.scrollView.showsVerticalScrollIndicator = NO;
        
        // [self reloadWebView];
      
        
        [twoAnimationView removeFromSuperview];
        twoAnimationView = nil;
        
        twoAnimationView = [[TwoAnimationView alloc]initWithFrame:CGRectMake(0, -83, SCREEN_WIDTH, 100)];
        
        twoAnimationView.layer.borderColor = [UIColor redColor].CGColor;
        
        [twoAnimationView Animation];
        
        [twoAnimationView Animation1];
        
        [localWebView.scrollView addSubview:twoAnimationView];
        
    }
}



#pragma mark 长按保存图片
- (void)longPressed:(UILongPressGestureRecognizer*)recognizer
{
    @try {
       
        if (recognizer.state != UIGestureRecognizerStateBegan) {
            return;
        }
        
        CGPoint touchPoint = [recognizer locationInView:localWebView];
        
        NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
        NSString *urlToSave = [localWebView stringByEvaluatingJavaScriptFromString:imgURL];
        
        if (urlToSave.length == 0) {
            _imageUrl = nil;
            return;
        }
        else{
            _imageUrl = urlToSave;
            [self showImageOptions];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)showImageOptions {
    
    @try {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"保存图片至系统相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        actionSheet.tag = 10001;
        [actionSheet showInView:self];

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    @try {
        
        if (actionSheet.tag == 10001) {
            if (buttonIndex == 0) {
                [self saveImageToDiskWithUrl:_imageUrl];
            }
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


- (void)saveImageToDiskWithUrl:(NSString *)imageUrl
{
    @try {
        UIImageView *imageView;
        NSURL *url = [NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self saveImageToDiskWithImage:image];
        }];

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)saveImageToDiskWithImage:(UIImage *)image {
    
    @try {
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    @try {
        if (error || !image) {
            [[HUDHelper getInstance] showErrorTipWithLabel:@"图片保存失败"];
        }else{
            [[HUDHelper getInstance] showErrorTipWithLabel:@"图片保存成功，请前往相册查看"];
        }
 
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


//网页开始加载代理方法调用
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    @try {
     
         [self JSContextMethod];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

//网页加载完成代理方法调用
- (void)webViewDidFinishLoad:(UIWebView *)webView{
 
    @try {
        
        [self JSContextMethod];
        currentURL = webView.request.URL.absoluteString;
        //    [self setGoBackBtn];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark 创建WKWebView
-(void)creatWKWebView{
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    
    //注册供js调用的方法
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    configuration.userContentController = userContentController;
    configuration.preferences.javaScriptEnabled = YES; //打开JavaScript交互 默认为YES
    //JS调用OC 添加处理脚本
    
    [userContentController addScriptMessageHandler:self name:@"NSReturnUserInfo"];
    [userContentController addScriptMessageHandler:self name:@"NSRefreshWebView"];
    [userContentController addScriptMessageHandler:self name:@"NSReadFileJumpToWebViewForWeb"];
    [userContentController addScriptMessageHandler:self name:@"NSdeleteRedPoint"];
    [localWKWebView removeFromSuperview];
    localWKWebView = nil;
    
    localWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -  0 - 50 * SCREEN_H_SP) configuration:configuration];
    
    localWKWebView.allowsBackForwardNavigationGestures =YES;//打开网页间的滑动返回
    localWKWebView.navigationDelegate = self;
    
    localWKWebView.allowsLinkPreview = YES;//允许预览链接
    
    NSURL *url = [[NSURL alloc]initWithString:formalSheQu_Html5];
    [localWKWebView loadRequest:[NSURLRequest requestWithURL:url]];
    [self addSubview:localWKWebView];
    
    localWKWebView.scrollView.showsVerticalScrollIndicator = NO;
    
    localWKWebView.UIDelegate = self;
    localWKWebView.scrollView.delegate = self;
    
    [twoAnimationView removeFromSuperview];
    twoAnimationView = nil;
    
    twoAnimationView = [[TwoAnimationView alloc]initWithFrame:CGRectMake(0, -83, SCREEN_WIDTH, 100)];
    
    twoAnimationView.layer.borderColor = [UIColor redColor].CGColor;
    
    [twoAnimationView Animation];
    
    [twoAnimationView Animation1];
    
    [localWKWebView.scrollView addSubview:twoAnimationView];
    
}

#pragma mark WKWebview加载网页开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
  //  [self JSMethod];
    //    [[HUDHelper getInstance] showLabelHUD   OnScreen:@"加载中" enabled:NO];
}

#pragma mark WKWebview加载网页完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self JSMethod];
    currentURL = webView.URL.absoluteString;
    
    
}


- (void)JSMethod {
    
    if (_tabrbarIntger == 1) {
        NSString *method = [NSString stringWithFormat:@"getiOSAppUserInfo('%@')",returnData];
        [localWKWebView evaluateJavaScript:method completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"输出  %@",response);
        }];
       
        [self reloadWebView];

        _tabrbarIntger = 2;
    }
}

// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message  {
    
    if ([message.name isEqualToString:@"NSRefreshWebView"]) {
        [self reloadWebView];
    }
    else
        if ([message.name isEqualToString:@"NSReadFileJumpToWebViewForWeb"]) {
            NSString *argsString = [NSString stringWithFormat:@"%@",message.body];
        
            NSData *jsonData = [argsString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *err;
            
            NSDictionary * getFileInfo = [NSJSONSerialization JSONObjectWithData:jsonData
                                          
                                                                         options:NSJSONReadingMutableContainers
                                          
                                                                           error:&err];
            
            
            
            NSString *url = getFileInfo[@"url"];
            if (!url) {
                url = @"";
            }
            NSString *title = getFileInfo[@"title"];
            if (!title) {
                title = @"";
            }
            
            [self readFileWithUrl:url title:title];
        }
        else
            if ([message.name isEqualToString:@"NSdeleteRedPoint"]) {
                NSString *argsString = [NSString stringWithFormat:@"%@",message.body];
                NSData *jsonData = [argsString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * argsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                
                NSDictionary *action = [[NSDictionary alloc] initWithDictionary:argsDic];
                NSString *toDo = action[@"toDo"];
                if ([toDo isEqualToString:@"delete"]) {
                    
                    [self.delegate disappearRedRoundLabel];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[AppDatas sharedDatas].userCode];
              }
            }
    //    if ([message.name isEqualToString:@"NSJumpToWebViewForWeb"]) {
    ////        NSDictionary *jumpInfo = [message.body objectFromJSONString];
    //
    //        NSString *vip_avatar = @"http://products-image.oss-cn-hangzhou.aliyuncs.com/ishowpsns/cms/unit/20170420YZBda8cCAm.pdf";
    //        BaseWebViewViewController *baseWebVC = [[BaseWebViewViewController alloc]init];
    //        baseWebVC.hideRightBtn = YES;
    //        baseWebVC.urlAddress = vip_avatar;
    //        [self.navigationController pushViewController:baseWebVC animated:YES];
    //    }
}



#pragma mark JS方法

- (void)JSContextMethod{
    
    @try {
        
        JSContext *context;
        
        context = [localWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

        if (_tabrbarIntger == 1) {
            
          
            context[@"NSReturnUserInfo"] = ^() {
                //返回用户个人信息
                
                return returnData;
            };

            _tabrbarIntger = 2;
        }
        
        context[@"NSReadFileJumpToWebViewForWeb"] = ^() {
            NSArray *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *argsString = [NSString stringWithFormat:@"%@",args[0]];
                
                NSData *jsonData = [argsString dataUsingEncoding:NSUTF8StringEncoding];
                
                NSError *err;
                
                NSDictionary * getFileInfo = [NSJSONSerialization JSONObjectWithData:jsonData
                                              
                                                                             options:NSJSONReadingMutableContainers
                                              
                                                                               error:&err];
                
                NSString *url = getFileInfo[@"url"];
                if (!url) {
                    url = @"";
                }
                NSString *title = getFileInfo[@"title"];
                if (!title) {
                    title = @"";
                }
                
                [self readFileWithUrl:url title:title];
                
            }
            //
        };
        
        context[@"NSRefreshWebView"] = ^() {
            [self reloadWebView];
            //        
        };
        
        
        context[@"NSdeleteRedPoint"] = ^() {
            NSArray *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *argsString = [NSString stringWithFormat:@"%@",args[0]];
                
                NSData *jsonData = [argsString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * argsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                
                NSDictionary *action = [[NSDictionary alloc] initWithDictionary:argsDic];
                NSString *toDo = action[@"toDo"];
                if ([toDo isEqualToString:@"delete"]) {

                [self.delegate disappearRedRoundLabel];
                    
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[AppDatas sharedDatas].userCode];
                }
            }
        };

        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
        
        
    } @finally {
        
    }
}

- (void)readFileWithUrl:(NSString *)url title:(NSString *)title{
    
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (url.length == 0) {
                
                [[HUDHelper getInstance]showErrorTipWithLabel:@"文件读取失败"];
                
                return;
            }
            if ([url hasSuffix:@".mp4"] ||
                [url hasSuffix:@".avi"] ||
                [url hasSuffix:@".mov"] ||
                [url hasSuffix:@".mpeg"]||
                [url hasSuffix:@".mpg"] ||
                [url hasSuffix:@".rmvb"]) {
                
                
                //            NSString *requestUrlStr =  [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                //            NSURL *requestUrl = [NSURL URLWithString:requestUrlStr];
                //
                //            NSMutableArray *photos = [[NSMutableArray alloc]init];
                //            MWPhoto *photo;
                //
                //            photo = [MWPhoto photoWithImage:[UIImage imageNamed:@"AppIcon"]];
                //            photo.videoURL = requestUrl;
                //
                //            [photos addObject:photo];
                //
                //            BOOL displayActionButton = NO;
                //            BOOL displaySelectionButtons = NO;
                //            BOOL displayNavArrows = NO;
                //            BOOL enableGrid = NO;
                //            BOOL startOnGrid = NO;
                //            BOOL autoPlayOnAppear = YES;
                //
                //            _photos = photos;
                //
                //            // Create browser
                //            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
                //            browser.displayActionButton = displayActionButton;
                //            browser.displayNavArrows = displayNavArrows;
                //            browser.displaySelectionButtons = displaySelectionButtons;
                //            browser.alwaysShowControls = displaySelectionButtons;
                //            browser.zoomPhotosToFill = YES;
                //            browser.enableGrid = enableGrid;
                //            browser.startOnGrid = startOnGrid;
                //            browser.enableSwipeToDismiss = NO;
                //            browser.autoPlayOnAppear = autoPlayOnAppear;
                //            [browser setCurrentPhotoIndex:0];
                //            [self.navigationController pushViewController:browser animated:YES];
                
                AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
#pragma mark  播放视频
                AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:url]];
                //2、创建视频播放视图的控制器
                AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
                //3、将创建的AVPlayer赋值给控制器自带的player
                playerVC.player = player;
                
                [tempAppDelegate netWorkNotificationShowTips:YES];
                
                //4、跳转到控制器播放
                [tempAppDelegate.mainNavigationController presentViewController:playerVC animated:YES completion:nil];
                [playerVC.player play];
                
            }
            else{
#pragma mark  页面跳转
                
                AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
                
                BaseWebViewViewController *baseWebVC = [[BaseWebViewViewController alloc]init];
                //            baseWebVC.hideRightBtn = YES;
                //           baseWebVC.hidesBottomBarWhenPushed = YES;
                baseWebVC.navigationItem.title = title;
                // baseWebVC.navBarHidden = NO;
                baseWebVC.urlString = url;
                [tempAppDelegate.mainNavigationController pushViewController:baseWebVC animated:YES];
            }
        });
 
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    @try {
     
        if (scrollView == localWebView.scrollView){
            [twoAnimationView startAnimation];
        }
        else if (scrollView == localWKWebView.scrollView){
            
            NSString *method = @"headerRefresh('headerRefresh')";
            [localWKWebView evaluateJavaScript:method completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                
                NSLog(@"输出  %@",response);
            }];

            
            [twoAnimationView startAnimation];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 即将结束拖拽

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    @try {
        if (localWebView.scrollView) {
            
            [twoAnimationView  stopAnimating];
            
            if (localWebView.scrollView.contentOffset.y < -25) {
                [twoAnimationView startAnimation1];
                
                localWebView.scrollView.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                
                [self reloadWebView];
                
            }
            
        }
        else if (scrollView == localWKWebView.scrollView){
            
                [twoAnimationView  stopAnimating];
            
            if (localWKWebView.scrollView.contentOffset.y < -25) {
                [twoAnimationView startAnimation1];
                
                NSString *method = @"headerRefresh('headerRefresh')";
                [localWKWebView evaluateJavaScript:method completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                    
                    NSLog(@"输出  %@",response);
                }];

                localWKWebView.scrollView.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                
                [self reloadWebView];
                
            }
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



-(void)reloadWebView{

    @try {
     
#pragma mark 注释WKWebView
//        NSString *version = [UIDevice currentDevice].systemVersion;
//        if (version.doubleValue >= 8.0) {
//            // 针对 8.0 以上的iOS系统进行处理
//            
//           [UIView animateWithDuration:0.5 animations:^{
//                
//               localWKWebView.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
//                
//            }completion:^(BOOL finished){
//                
//                [twoAnimationView stopAnimating1];
//            }];
//            
//
//            
//            if (currentURL.length > 0) {
//                //获取并重新加载当前页面的URL
//                [localWKWebView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:currentURL]]];
//            }
//            else{
//                [localWKWebView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:formalSheQu_Html5]]];
//            }
//
//            
//        } else {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            localWebView.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
            
        }completion:^(BOOL finished){
           
            [twoAnimationView stopAnimating1];
        }];
        
        
        if (currentURL.length > 0) {
                //获取并重新加载当前页面的URL
            [localWebView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:currentURL]]];
       
        }
       else{
           
           [localWebView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:formalSheQu_Html5]]];
       }
            
 //   }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



@end
