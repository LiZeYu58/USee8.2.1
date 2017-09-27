//
//  ShareMenuViewController.m
//  LOSBi
//
//  Created by gufeifei on 16/8/16.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "ShareMenuViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BoardView.h"
#import "LOSHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "MBProgressHUD+ZW.h"


@interface ShareMenuViewController ()<MFMailComposeViewControllerDelegate, MBProgressHUDDelegate>
{
    UIButton *_wechatBtn;
    UIButton *_socialBtn;
    UIButton *_mailBtn;
    UIButton *_photoBtn;
    UIButton *closeBtn;
    MFMailComposeViewController *mfm;
    MBProgressHUD *HUD;
    BoardView *drewArea;

}

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIImage  *shareImage1;

//@property (nonatomic, strong) UIImage  *shareImage2;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIImageView *imgView1;
@end

@implementation ShareMenuViewController

- (instancetype)initWithShareBtn:(UIButton *)inShareBtn {
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        self.shareBtn = inShareBtn;
        
     self.shareImage1 = [LOSHelper getSnapshotImage];
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView * blackView = [[UIView alloc] initWithFrame:self.view.bounds];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    
    UIImageView * ima = [[UIImageView alloc]initWithFrame:blackView.bounds];
    ima.image = self.shareImage1;
    [blackView addSubview:ima];
    
    drewArea = [[BoardView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:drewArea];

    _wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _wechatBtn.frame = CGRectMake(DeviceWidth - 70, 64 + 10 + 62 * 0, 62, 62);
    [_wechatBtn setImage:[UIImage imageNamed:@"btn_分享到微信"] forState:UIControlStateNormal];
    [_wechatBtn setImage:[UIImage imageNamed:@"btn_分享到微信_d"] forState:UIControlStateHighlighted];
    [_wechatBtn addTarget:self action:@selector(wechatBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_wechatBtn];

    
    _mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mailBtn.frame = CGRectMake(DeviceWidth - 70, 64 + 10 + 62 * 1, 62, 62);
    [_mailBtn setImage:[UIImage imageNamed:@"btn_分享到消息"] forState:UIControlStateNormal];
    [_mailBtn setImage:[UIImage imageNamed:@"btn_分享到消息_d"] forState:UIControlStateHighlighted];
    [_mailBtn addTarget:self action:@selector(mailBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mailBtn];
    
    _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _photoBtn.frame = CGRectMake(DeviceWidth - 70, 64 + 10 + 62 * 2, 62, 62);
    [_photoBtn setImage:[UIImage imageNamed:@"btn_下载"] forState:UIControlStateNormal];
    [_photoBtn setImage:[UIImage imageNamed:@"btn_下载_d"] forState:UIControlStateHighlighted];
    [_photoBtn addTarget:self action:@selector(photoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_photoBtn];
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(DeviceWidth - 70, 64 + 10 + 62 * 3, 62, 62);
    [closeBtn setImage:[UIImage imageNamed:@"btn_取消"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"btn_取消_d"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(cancelTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];

}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
//    self.shareImage2 = [LOSHelper getSnapshotImage];
    
}


#pragma mark - 微信分享按钮
- (void)wechatBtnClicked {
    
    [_wechatBtn setHidden:YES];
    [_photoBtn setHidden:YES];
    [_mailBtn setHidden:YES];
    [closeBtn setHidden:YES];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), NO, 2.0);
    
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) afterScreenUpdates:NO];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    [_wechatBtn setHidden:NO];
    [_photoBtn setHidden:NO];
    [_mailBtn setHidden:NO];
    [closeBtn setHidden:NO];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:@""
                                     images:newImage     //截图
                                        url:nil
                                      title:nil
                                       type:SSDKContentTypeImage];

#pragma mark - 2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateSuccess: {
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                           
                       }
                           
                       case SSDKResponseStateFail: {
                           
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                           
                       }
                           
                       default:
                           
                           break;
                           
                   }
                   
               }
     ];

}

- (void)socialBtnClicked {

    
}

#pragma mark - 邮件发送按钮
- (void)mailBtnClicked {
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (!mailClass) {
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = @"当前系统版本不支持邮箱功能";
        HUD.labelFont = [UIFont systemFontOfSize:13];
        HUD.margin = 10.f;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES afterDelay:2];
        
        return;
    }
    
    if (![mailClass canSendMail]) {
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = @"请到系统设置中配置邮箱";
        HUD.margin = 10.f;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES afterDelay:2];
        return;
    }
    
    [self displayMailPicker];
    
}

#pragma mark - 调出邮件发送窗口
- (void)displayMailPicker {
    
    [_wechatBtn setHidden:YES];
    [_photoBtn setHidden:YES];
    [_mailBtn setHidden:YES];
    [closeBtn setHidden:YES];
    
    UIGraphicsBeginImageContext(drewArea.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    [_wechatBtn setHidden:NO];
    [_photoBtn setHidden:NO];
    [_mailBtn setHidden:NO];
    [closeBtn setHidden:NO];
    
    mfm = [[MFMailComposeViewController alloc] init];
    mfm.mailComposeDelegate = self;
    
    //设置主题
    [mfm setSubject: @""];
    [mfm setMessageBody:@"" isHTML:YES];
    
    NSDate *timestamp = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:timestamp];
    NSString *imageFileName = [@"USee" stringByAppendingFormat:@"_%@%@", currentDateStr, @".png"];
    
    // 添加图片
    NSData *imageData = UIImagePNGRepresentation(newImage);
    [mfm addAttachmentData: imageData mimeType: @"image/png" fileName: imageFileName];
    
    [self presentViewController:mfm animated:YES completion:nil];
    
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *msg;
    
    switch (result) {
        case MFMailComposeResultCancelled:
            
            msg = @"用户取消编辑邮件";
            break;
            
        case MFMailComposeResultSaved:
            
            msg = @"用户成功保存邮件";
            break;
            
        case MFMailComposeResultSent:
            
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
            
        case MFMailComposeResultFailed:
            
            msg = @"用户试图保存或者发送邮件失败";
            break;
            
        default:
            
            msg = @"";
            break;
            
    }
    
}

#pragma mark - 图片分享按钮
- (void)photoBtnClicked {
    DLogObject(@"photoBtnClicked");
    
    [_wechatBtn setHidden:YES];
    [_photoBtn setHidden:YES];
    [_mailBtn setHidden:YES];
    [closeBtn setHidden:YES];
    
    UIGraphicsBeginImageContext(drewArea.frame.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    [_wechatBtn setHidden:NO];
    [_photoBtn setHidden:NO];
    [_mailBtn setHidden:NO];
    [closeBtn setHidden:NO];
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    UIAlertController *alertController;
    AppDelegate *tempAppDelegate;
    
    switch (author) {
            
        case ALAuthorizationStatusRestricted:
            
            
            
        case ALAuthorizationStatusDenied:
            
            alertController = [UIAlertController alertControllerWithTitle:nil message:@"请前往设置, 开启相册访问权限" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            break;
            
        default:
            
            UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            break;
            
    }
    
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error) {
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = @"成功保存到相册";
        HUD.margin = 10.f;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES afterDelay:2];
        
    } else {
        
        DLog(@"%@", [error description]);
        
    }
    
}

#pragma mark -
#pragma mark HUD的代理方法,关闭HUD时执行
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}


- (void)cancelTap {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

@end
