//
//  LoginViewController.m
//  Black-Weekend
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
@interface LoginViewController ()
- (IBAction)addBtn:(id)sender;
- (IBAction)deleteBtn:(id)sender;
- (IBAction)updateBtn:(id)sender;
- (IBAction)selectBtn:(id)sender;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *rightBarbtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarbtn;
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = MineColor;
    [self showBackButton];
}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)addBtn:(id)sender {
    //往User表中添加一条数据
    BmobObject *user = [BmobObject objectWithClassName:@"Beauty"];
    [user setObject:@"韩苇棋" forKey:@"user_Name"];
    [user setObject: @18 forKey:@"user_Age"];
    [user setObject:@"女" forKey:@"user_Gender"];
    [user setObject:@"18860233262" forKey:@"user_cellPhoneNumber"];
    [user setObject:[NSNumber numberWithBool:YES] forKey:@"cheatMode"];
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
        LXJLog(@"注册成功！");
    }];
}

- (IBAction)deleteBtn:(id)sender {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Beauty"];
    [bquery getObjectInBackgroundWithId:@"64075aa352" block:^(BmobObject *object, NSError *error){
        if (error) {
            //进行错误处理
        }
        else{
            if (object) {
                //异步删除object
                [object deleteInBackground];
            }
        }
    }];
}

- (IBAction)updateBtn:(id)sender {
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Beauty"];
    //查找GameScore表里面id为f6dcc5ec81的数据
    [bquery getObjectInBackgroundWithId:@"f6dcc5ec81" block:^(BmobObject *object,NSError *error){
        //没有返回错误
        if (!error) {
            //对象存在
            if (object) {
                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                //设置cheatMode为YES
                [obj1 setObject:[NSNumber numberWithBool:YES] forKey:@"cheatMode"];
                //异步更新数据
                [obj1 updateInBackground];
            }
        }else{
            //进行错误处理
        }
    }];
}

- (IBAction)selectBtn:(id)sender {
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Beauty"];
    //查找GameScore表里面id为f6dcc5ec81的数据
    [bquery getObjectInBackgroundWithId:@"f6dcc5ec81" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为c9dd9001e0的数据
            if (object) {
                //得到playerName和cheatMode
                NSString *playerName = [object objectForKey:@"user_Name"];
                NSString *phonenumber = [object objectForKey:@"user_cellPhoneNumber"];
                NSLog(@"%@----%@",playerName,phonenumber);
            }
        }
    }];
}


@end
