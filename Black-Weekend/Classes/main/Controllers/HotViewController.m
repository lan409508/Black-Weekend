//
//  HotViewController.m
//  Black-Weekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "HotViewController.h"
#import "PullingRefreshTableView.h"
#import "HotViewController.h"
#import "HotTableViewCell.h"
#import "ThemeViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface HotViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount; //定义请求的页码
}
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *listArray;
@property(nonatomic, strong) UILabel *praiseLabel;

@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self showBackButton];
    self.title = @"热门专题";
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 160;
    [self.tableView registerNib:[UINib nibWithNibName:@"HotTableViewCell"  bundle:nil]forCellReuseIdentifier:@"cell"];
    self.praiseLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 55, 130, 40, 20)];
    self.praiseLabel.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:self.praiseLabel];
    [self.tableView launchRefreshing];
}

#pragma mark --------- DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotTableViewCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    hotCell.hotModel = self.listArray[indexPath.row];
    return hotCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
   
    return self.listArray.count;
}

#pragma mark ---------- TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HotModel *model = self.listArray[indexPath.row];
    ThemeViewController *themeVC = [[ThemeViewController alloc]init];
    themeVC.themeId = model.hotId;
    [self.navigationController pushViewController:themeVC animated:YES];
}

#pragma mark ---------- PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    [self performSelector:@selector(loadData ) withObject:nil afterDelay:1.0];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}

//加载数据
- (void)loadData {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@",Hot] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"]integerValue];
        self.listArray = [NSMutableArray new];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *rcArray = dict[@"rcData"];
            for (NSDictionary *rcDic in rcArray) {
                HotModel *model = [[HotModel alloc]initWithDictionary:rcDic];
                
                [self.listArray addObject:model];
                
            }
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
            [self.tableView reloadData];
            
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    //完成加载
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}

//手指拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark ---------- 懒加载

- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    return _tableView;
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
