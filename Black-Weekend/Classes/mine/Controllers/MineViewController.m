//
//  MineViewController.m
//  Black-Weekend
//  我的
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "MineViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MessageUI.h>
#import "ProgressHUD.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "LoginViewController.h"
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,WXApiDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIButton *headImageBtn;
@property (nonatomic, strong) UILabel *nikeNamelabel;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *grayView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 40, 40);
//    [rightBtn setImage: [UIImage imageNamed: @"set_normal"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(searchActivityAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarbtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightBarbtn;
    
    [self.view addSubview:self.tableView];
    self.navigationController.navigationBar.barTintColor = MineColor;
    self.imageArray = @[@"icon_user",@"icon_like",@"icon_msg",@"icon_ac",@"icon_ele"];
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除图片缓存",@"用户反馈",@"分享给朋友",@"给我评分",@"当前版本1.0",nil];
    
    [self setUpViewTableViewHeaderView];
}

- (void)viewWillAppear:(BOOL)animated{
    //当页面将要出现的时候重新计算图片缓存大小
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除图片缓存(%.2fM)",(float)cacheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark -------- UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 4;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    //去掉cell选中颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}



#pragma mark -------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要删除缓存?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                LXJLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
                SDImageCache *imageCache = [SDImageCache sharedImageCache];
                [imageCache clearDisk];
                [self.titleArray replaceObjectAtIndex:0 withObject:@"清除图片缓存"];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }];
            UIAlertAction* defaultAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:defaultAction];
            [alert addAction:defaultAction1];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
            break;
        case 1:
        {
            //发送邮件
            [self sendEmail];
        }
            break;
        case 2:
        {
            //分享
            [self share];
        }
            
            break;
        case 3:
        {
            //appStore评分
            NSString *str = [NSString stringWithFormat:
                             @"itms-apps://itunes.apple.com/app"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 4:
        {
            //检测当前版本
            [ProgressHUD show:@"正在为您检测中..."];
            [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:2.0];
        }
            break;
        default:
            break;
    }
}
//
//#pragma mark -------- 微博代理方法
//
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
//
//}
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
//
//}

#pragma mark -------- Custom Method

- (void)setUpViewTableViewHeaderView {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
    headView.backgroundColor = MineColor;
    self.tableView.tableHeaderView = headView;
    [headView addSubview:self.headImageBtn];
    [headView addSubview:self.nikeNamelabel];
}

- (void)searchActivityAction{
    
}

#pragma mark -------- 懒加载

- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 30) style:UITableViewStylePlain];
        self.tableView.separatorColor = [UIColor darkGrayColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    return _tableView;
}

- (UIButton *)headImageBtn {
    if (_headImageBtn == nil) {
        self.headImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageBtn.frame = CGRectMake(20, 40, 130, 130);
        [self.headImageBtn setTitle:@"登录、注册" forState:UIControlStateNormal];
        [self.headImageBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self.headImageBtn setBackgroundColor:[UIColor whiteColor]];
        [self.headImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.headImageBtn.layer.cornerRadius = 65.0;
        self.headImageBtn.clipsToBounds = YES;
    }
    return _headImageBtn;
}

- (UILabel *)nikeNamelabel {
    if (_nikeNamelabel == nil) {
        self.nikeNamelabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 80, kScreenWidth - 200, 60)];
        self.nikeNamelabel.numberOfLines = 0;
        self.nikeNamelabel.text =@"欢迎来到Black-Weekend";
        self.nikeNamelabel.textColor = [UIColor whiteColor];
    }
    return _nikeNamelabel;
}

- (void)share{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.grayView.backgroundColor = [UIColor blackColor];
    self.grayView.alpha = 0.5;
    [window addSubview:self.grayView];
    
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 200, kScreenWidth, 250)];
    self.shareView.backgroundColor = [UIColor colorWithRed:234/255.0 green:243/255.0 blue:246/255.0 alpha:1.0];
    [window addSubview:self.shareView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shareView.frame = CGRectMake(0, kScreenHeight - 250, kScreenWidth, 250);
    }];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(160, 10, 100, 44)];
    label.text = @"分享到";
    label.textColor = [UIColor blackColor];
    [self.shareView addSubview:label];
    
    //微博
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(40, 40, 70, 70);
    [weiboBtn setImage:[UIImage imageNamed:@"share_weibo-1"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(SendRequest) forControlEvents:UIControlEventTouchUpInside];
    UILabel *weiboLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 100, 70, 20)];
    weiboLabel.text = @"新浪微博";
    weiboLabel.textColor = [UIColor darkGrayColor];
    weiboLabel.font = [UIFont systemFontOfSize:13.0];
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:weiboLabel];
    [self.shareView addSubview:weiboBtn];
    
    //朋友
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(150, 40, 70, 70);
    [friendBtn setImage:[UIImage imageNamed:@"share_friend"] forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(friend) forControlEvents:UIControlEventTouchUpInside];
    UILabel *friendLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 100, 70, 20)];
    friendLabel.text = @"微信好友";
    friendLabel.textColor = [UIColor darkGrayColor];
    friendLabel.font = [UIFont systemFontOfSize:13.0];
    friendLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:friendLabel];
    [self.shareView addSubview:friendBtn];
    
    //朋友圈
    UIButton *quanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quanBtn.frame = CGRectMake(260, 40, 70, 70);
    [quanBtn setImage:[UIImage imageNamed:@"share_friends"] forState:UIControlStateNormal];
    [quanBtn addTarget:self action:@selector(testMessagesAct) forControlEvents:UIControlEventTouchUpInside];
    UILabel *quanLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 100, 70, 20)];
    quanLabel.text = @"微信朋友圈";
    quanLabel.textColor = [UIColor darkGrayColor];
    quanLabel.font = [UIFont systemFontOfSize:13.0];
    quanLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:quanLabel];
    [self.shareView addSubview:quanBtn];
    
    //QQ
//    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    qqBtn.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    //qq空间
    
    
    //remove
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(0, 200, kScreenWidth, 40);
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    removeBtn.backgroundColor = [UIColor whiteColor];
    [removeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    
}

- (void)testMessagesAct{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"这是测试发送的内容。";
    req.bText = YES;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void)checkAppVersion{
    [ProgressHUD showSuccess:@"已是最新版本"];
}

- (void)remove {
    [self.shareView removeFromSuperview];
    [self.grayView removeFromSuperview];
}

- (void)SendRequest {
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbToken];
    request.userInfo = @{@"ShareMessageFrom": @"MeViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    [self remove];
    
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"啦啦啦，回家回家";
    return message;
}





- (void)friend {
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"这是测试发送的内容。";
    req.bText = YES;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void)quan {
    
}

- (void)login {
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)sendEmail {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            //初始化
            MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc]init];
            //设置代理
            mailVC.mailComposeDelegate= self;
            //设置主题
            [mailVC setSubject:@"用户反馈"];
            //设置收件人
            NSArray *receive = [NSArray arrayWithObjects:@"2742684905@qq.com",nil];
            [mailVC setToRecipients:receive];
            
            //设置发送内容
            NSString *text = @"留下您宝贵的意见";
            [mailVC setMessageBody:text isHTML:NO];
            
            //推出视图
            [self presentViewController:mailVC animated:YES completion:nil];
        } else {
            LXJLog(@"未配置邮箱");
        }
    } else {
        LXJLog(@"当前设备不支持");
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            LXJLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved:
            LXJLog(@"MFMailComposeResultSaved-保存");
            break;
        case MFMailComposeResultSent:
            LXJLog(@"MFMailComposeResultSent-发送");
            break;
        case MFMailComposeResultFailed:
            LXJLog(@"MFMailComposeResultFailed-失败");
            break;
        default:
            break;
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
