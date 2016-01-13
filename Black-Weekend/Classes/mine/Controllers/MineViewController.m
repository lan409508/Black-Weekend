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
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIButton *headImageBtn;
@property (nonatomic, strong) UILabel *nikeNamelabel;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

            LXJLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            [imageCache clearDisk];
            [self.titleArray replaceObjectAtIndex:0 withObject:@"清除图片缓存"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark -------- Custom Method

- (void)setUpViewTableViewHeaderView {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
    headView.backgroundColor = MineColor;
    self.tableView.tableHeaderView = headView;
    [headView addSubview:self.headImageBtn];
    [headView addSubview:self.nikeNamelabel];
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

- (void)checkAppVersion{
    [ProgressHUD showSuccess:@"已是最新版本"];
}

- (void)login {
    
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
