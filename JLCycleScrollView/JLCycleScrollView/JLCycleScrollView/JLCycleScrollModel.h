//
//  JLCycleScrollModel.h
//  JLCycleScrollView
//
//  Created by 王俊岭 on 2017/3/15.
//  Copyright © 2017年 王俊岭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLCycleScrollModel : NSObject
///轮播图片的URL
@property (nonatomic, copy) NSString *imgURL;
///跳转的URL
@property (nonatomic, copy) NSString *jumpURL;
///该条轮播消息的id
@property (nonatomic, copy) NSString *cycleID;
///其他参数;
@property (nonatomic, strong) NSDictionary *extraParams;
@end
