//
//  DiscoverModel.h
//  Black-Weekend
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverModel : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, strong) NSString *activityId;
@property(nonatomic, strong) NSString *type;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
