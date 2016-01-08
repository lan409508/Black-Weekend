//
//  ActivityDetailViewController.m
//  Black-Weekend
//  活动详情
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "AFNetworking/AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "ActivityDetailView.h"
#import "AppDelegate.h"
@interface ActivityDetailViewController ()

{
    NSString *_phoneNumber;
}

@property (strong, nonatomic) IBOutlet ActivityDetailView *activityDetailView;



@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"活动详情";
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    [self showBackButton];
    
    //去地图页面
    
    //打电话
    [self.activityDetailView.makeCallButton addTarget:self action:@selector(makeCallButtonAction:) forControlEvents:UIControlEventTouchUpInside
     ];
    [self getModel];
}

#pragma mark --------- Custom  Method

- (void)getModel{
    AFHTTPSessionManager *sessionMaganer = [AFHTTPSessionManager manager];
    sessionMaganer.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [sessionMaganer GET:[NSString stringWithFormat:@"%@&id=%@",kActivityDetail,self.activityId] parameters:nil progress: ^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            
            NSDictionary *successDic = dic[@"success"]; 
            self.activityDetailView.dataDic = successDic;
            _phoneNumber = dic[@"tel"];
            
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        LXJLog("%@",error);
    }];
}

//去地图页
- (void)mapButtonAction:(UIButton *)btn{
    
}

//打电话
- (void)makeCallButtonAction:(UIButton *)btn {
    //程序外打电话，打完电话之后不返回当前应用程序
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneNumber]]];
    
    
    //程序内打电话，打完电话之后返回当前应用程序
    UIWebView *cellphoneWebView = [[UIWebView alloc]init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneNumber]]];
    [cellphoneWebView loadRequest:request];
    [self.view addSubview:cellphoneWebView];
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
