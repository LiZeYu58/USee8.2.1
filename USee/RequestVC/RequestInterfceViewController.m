//
//  RequestInterfceViewController.m
//  iShow
//
//  Created by 李泽雨 on 2017/1/18.
//  Copyright © 2017年 Bizvane. All rights reserved.
//

#import "RequestInterfceViewController.h"

@interface RequestInterfceViewController ()

@end

@implementation RequestInterfceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

#pragma mark 报名接口请求
-(void)requestEnrollInterface:(NSString *)interfaceString requestDic:(NSDictionary *)dic{
    
    @try {
        
#pragma mark  检查网络
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                [[LOSAFNetworking new] POST:interfaceString
                             dataParameters:dic
                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            //      [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            
                                            self.successBlock(responseDic);
                                        });
                                    }
                                    failure:^(NSError *error) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            //   [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            self.errolBlock(error.code);
                                            
                                            
                                        });
                                    }];
                
            });
        }
        else{
            self.noNetworkBlock();
        }
            
    } @catch (NSException *exception) {
        
        NSLog(@"崩溃信息  %@",exception);
    } @finally {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
