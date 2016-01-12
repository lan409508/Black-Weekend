//
//  ClassifyViewController.m
//  Black-Weekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "ClassifyViewController.h"
#import "PullingRefreshTableView.h"
#import "ActivityDetailViewController.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "VOSegmentedControl.h"
#import "ProgressHUD.h"
#import "ActivityDetailViewController.h"
@interface ClassifyViewController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
    NSInteger _pageCount; //定义请求的页码
}
@property(nonatomic, assign) BOOL refreshing;

@property (nonatomic, strong) PullingRefreshTableView *tableView;
//用来负责展示的数组
@property (nonatomic, strong) NSMutableArray *showDataArray;
@property (nonatomic, strong) NSMutableArray *showArray;
@property (nonatomic, strong) NSMutableArray *touristArray;
@property (nonatomic, strong) NSMutableArray *studyArray;
@property (nonatomic, strong) NSMutableArray *familyArray;
@property (nonatomic, strong) VOSegmentedControl *segmentedControl;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类列表";
    [self showBackButton];
    _pageCount = 1;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.showDataArray = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityTableViewCell"  bundle:nil]forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 90;
    [self.tableView launchRefreshing];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.tableView];
    
    [self chooseRequest];
 
}

#pragma mark --------- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityTableViewCell *activityCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    activityCell.activityModel = self.showDataArray[indexPath.row];
    return activityCell;
}

#pragma mark --------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取点击那一行的数据
    ActivityModel *model = self.showDataArray[indexPath.row];
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *actVC = [main instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
    //活动id
    actVC.activityId = model.activityId;
    [self.navigationController pushViewController:actVC animated:YES];
}


#pragma mark --------- PullingRefreshTableViewDelegate
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView {
        _pageCount = 1;
        self.refreshing = YES;
        [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}
//上拉加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView {
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}

#pragma mark --------- VOSegmentedControl
- (void) segmentCtrlValuechange:(VOSegmentedControl *)segmentedControl{
    self.classifyListType = segmentedControl.selectedSegmentIndex + 1;
    [self chooseRequest];
}
#pragma mark --------- Custom Method


- (void)getShowRequest {
    //typeid = 6 演出剧目
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",Classify,_pageCount,@(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            //下拉删除原来数据
            if (self.refreshing) {
                if (self.showArray.count > 0) {
                    [self.showArray removeAllObjects];
                }
            }
            for (NSDictionary *dic0 in acArray) {
                ActivityModel *model = [[ActivityModel alloc] initWithDictionary:dic0];
                [self.showArray addObject:model];
            }
        } else {
            
        }
        [self showPreviousSelectBtn];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}
- (void)getTouristRequest{
    //typeid = 23 景点场馆
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",Classify,_pageCount,@(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            //下拉删除原来数据
            if (self.refreshing) {
                if (self.touristArray.count > 0) {
                    [self.touristArray removeAllObjects];
                }
            }
            for (NSDictionary *dic1 in acArray) {
                ActivityModel *model = [[ActivityModel alloc] initWithDictionary:dic1];
                [self.touristArray addObject:model];
            }
        } else {
            
        }
        [self showPreviousSelectBtn];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)getStudyRequest{
    //typeid = 22 学习益智
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",Classify,_pageCount,@(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            //下拉删除原来数据
            if (self.refreshing) {
                if (self.studyArray.count > 0) {
                    [self.studyArray removeAllObjects];
                }
            }
            for (NSDictionary *dic2 in acArray) {
                ActivityModel *model = [[ActivityModel alloc] initWithDictionary:dic2];
                [self.studyArray addObject:model];
            }
        } else {
            
        }
        [self showPreviousSelectBtn];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)getFamilyRequest{
    //typeid = 21 亲子旅游
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    [sessionManager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",Classify,_pageCount,@(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *acArray = dict[@"acData"];
            //下拉删除原来数据
            if (self.refreshing) {
                if (self.familyArray.count > 0) {
                    [self.familyArray removeAllObjects];
                }
            }
            for (NSDictionary *dic3 in acArray) {
                ActivityModel *model = [[ActivityModel alloc] initWithDictionary:dic3];
                [self.familyArray addObject:model];
            }
        } else {
            
        }
        [self showPreviousSelectBtn];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
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

- (void)showPreviousSelectBtn {
    if (self.refreshing) {
        if (self.showDataArray.count > 0) {//下拉删除原来的数据
            [self.showDataArray removeAllObjects];
        }
    }
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
        {
            self.showDataArray = self.showArray;
        }
            break;
        case ClassifyListTypeTouristPlace:
        {
            self.showDataArray = self.touristArray;
        }
            break;
        case ClassifyListTypeStudyPUZ:
        {
            self.showDataArray = self.studyArray;
        }
            break;
        case ClassifyListTypeFamilyTravel:
        {
            self.showDataArray = self.familyArray;
        }
            break;
        default:
            break;
    }
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    [self.tableView reloadData];
    
}

- (void)chooseRequest {
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
            [self getShowRequest];
            break;
        case ClassifyListTypeTouristPlace:
            [self getTouristRequest];
            break;
        case ClassifyListTypeStudyPUZ:
            [self getStudyRequest];
            break;
        case ClassifyListTypeFamilyTravel:
            [self getFamilyRequest];
            break;
        default:
            break;
    }
}

//在页面将要消失的时候去掉所有的圈圈
- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [ProgressHUD dismiss];
}

#pragma mark --------- 懒加载
- (PullingRefreshTableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 60 - 40) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)showDataArray {
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}

- (NSMutableArray *)showArray {
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}

- (NSMutableArray *)touristArray {
    if (_touristArray == nil) {
        self.touristArray = [NSMutableArray new];
    }
    return _touristArray;
}

- (NSMutableArray *)studyArray {
    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;
}

- (NSMutableArray *)familyArray {
    if (_familyArray == nil) {
        self.familyArray = [NSMutableArray new];
    }
    return _familyArray;
}

- (VOSegmentedControl *)segmentedControl {
    if (_segmentedControl == nil) {
        self.segmentedControl = [[VOSegmentedControl alloc]initWithSegments:@[@{VOSegmentText:@"演出剧目"},@{VOSegmentText:@"景点场馆"},@{VOSegmentText:@"学习益智"},@{VOSegmentText:@"亲子旅游"}]];
        self.segmentedControl.contentStyle = VOContentStyleTextAlone;
        self.segmentedControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segmentedControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segmentedControl.selectedBackgroundColor = self.segmentedControl.backgroundColor;
        self.segmentedControl.allowNoSelection = NO;
        self.segmentedControl.frame = CGRectMake(0, 0, kScreenWidth, 40);
        self.segmentedControl.indicatorThickness = 4;
        self.segmentedControl.selectedSegmentIndex = self.classifyListType - 1;
        [self.view addSubview:self.segmentedControl];
        
        [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {

        }];
        [self.segmentedControl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
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
