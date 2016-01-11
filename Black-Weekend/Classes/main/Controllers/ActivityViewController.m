//
//  ActivityViewController.m
//  Black-Weekend
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "ActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import "ActivityDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount; //定义请求的页码
}
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *listArray;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButton];
    self.listArray = [NSMutableArray new];

    self.title = @"精选活动";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityTableViewCell"  bundle:nil]forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 90;
    [self.tableView launchRefreshing];
}

#pragma mark --------- DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityTableViewCell *activityCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    activityCell.activityModel = self.listArray[indexPath.row];
    return activityCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
}

#pragma mark ---------- TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取点击那一行的数据
    ActivityModel *model = self.listArray[indexPath.row];
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *actVC = [main instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
    
    //活动id
    actVC.activityId = model.activityId;
    [self.navigationController pushViewController:actVC animated:YES];
}

#pragma mark ---------- PullingRefreshTableViewDelegate
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
//上拉加载更多
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
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
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld",kActivity,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"]integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            if (self.refreshing) {
                //下拉刷新的时候需要移除数组中的元素
                if (self.listArray.count > 0) {
                    [self.listArray removeAllObjects];
                }
            }
            for (NSDictionary *acDic in acArray) {
                ActivityModel *model = [[ActivityModel alloc]initWithDictionary:acDic];
                [self.listArray addObject:model];
            }
            
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
            //刷新tableView,它会重新执行tableView的所有代理方法 
            [self.tableView reloadData];
        
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
