//
//  TableViewCellForLeftBarOfMainPage.m
//  LOSBi
//
//  Created by gufeifei on 16/8/12.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewCellForLeftBarOfMainPage.h"
#import "LeftSlideViewController.h"
#import "AppDatas.h"
@interface TableViewCellForLeftBarOfMainPage () {
    UIImageView *_imageView;
    UILabel *_label;
    
    UIView *_backgroungView;
}

@end

@implementation TableViewCellForLeftBarOfMainPage

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;

        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0];
        
        
        float leftWidth = DeviceWidth - kMainPageDistance;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((leftWidth - 22) / 2, 15, 22, 22)];
        [self.contentView addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, leftWidth, 30)];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:13];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)setBackgroundHidden:(BOOL)isHidden {
    
    if (isHidden) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.05];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    DLogObject(@"setFrame");
    
    float imageSize = 22 * SCREEN_W_SP;
   // if (frame.size.height > 70) {
   //     imageSize = 40;
   // }
    _imageView.frame = CGRectMake((frame.size.width - imageSize) / 2, frame.size.height / 2 - imageSize, imageSize, imageSize);
    _label.frame = CGRectMake(0, frame.size.height / 2 + 5, frame.size.width, 30);

}

- (void)setIndex:(NSInteger)inIndex {
    switch (inIndex) {
        case 0:
            
        {
            //用户
            _imageView.image = [UIImage imageNamed:@"icon_menu_user"];
            
            NSDictionary *userPersonalInformation = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPersonalInformation"];
        

            _label.text = userPersonalInformation[@"user_name"];
            
        }
            break;
        case 1:
            //操作手册
            _imageView.image = [UIImage imageNamed:@"icon_menu_manual"];
            _label.text = @"操作手册";
            break;
        case 2:
            //手势密码
            _imageView.image = [UIImage imageNamed:@"icon_menu_password.png"];
            _label.text = @"手势密码";
            break;
       // case 5:
            //意见反馈
          //  _imageView.image = [UIImage imageNamed:@"icon_menu_feedback"];
          //  _label.text = @"意见反馈";
          //  break;
        //case 6:
            //联系我们
          //  _imageView.image = [UIImage imageNamed:@"icon_menu_contact"];
          //  _label.text = @"联系我们";
          //  break;
        case 3:
            //分享有数
            _imageView.image = [UIImage imageNamed:@"icon_menu_share"];
            _label.text = @"分享有数";
            break;
        case 4:
            //注销账号
            _imageView.image = [UIImage imageNamed:@"icon_menu_logout"];
            _label.text = @"注销账号";
            break;
        
            
        default:
            break;
    }
    [self setBackgroundHidden:inIndex % 2 == 0 ? NO : YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

}

@end
