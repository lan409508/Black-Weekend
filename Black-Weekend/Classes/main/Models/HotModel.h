//
//  HotModel.h
//  Black-Weekend
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotModel : NSObject

@property(nonatomic, copy) NSString *headImage;
@property(nonatomic, strong) NSString *hotId;

- (instancetype) initWithDictionary:(NSDictionary *)dict;

@end
