//
//  MainModel.m
//  Black-Weekend
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.type = dic[@"type"];
        if ([self.type integerValue] == RecommendTypeActivity) //如果是推荐活动
        {
            self.price = dic[@"price"];
            self.lat = [dic[@"lat"] floatValue];
            self.lng = [dic[@"lng"] floatValue];
            self.address = dic[@"address"];
            self.counts = dic[@"counts"];
            self.startTime = dic[@"startTime"];
            self.endTime = dic[@"endTime"];
            self.iamge_big = dic[@"image_big"];
            self.title = dic[@"title"];
            self.activityId = dic[@"id"];
        } else {
            //如果是推荐专题
            self.activityDescription = dic[@"description"];
        }
        self.iamge_big = dic[@"image_big"];
//        self.title = dic[@"title"];
//        self.activityId = dic[@"id"];
    }
    return self;
}


@end
