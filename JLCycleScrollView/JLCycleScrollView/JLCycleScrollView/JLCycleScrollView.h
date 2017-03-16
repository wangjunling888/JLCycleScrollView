//
//  JLCycleScrollView.h
//  JLCycleScrollView
//
//  Created by 王俊岭 on 2017/3/15.
//  Copyright © 2017年 王俊岭. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JLCycleScrollModel.h"

typedef void(^JLCycleScrollDidClickedBlock)(NSInteger index, JLCycleScrollModel *model);


@interface JLCycleScrollView : UIView

@property (nonatomic, strong) NSArray <JLCycleScrollModel *> *dataArr;

@property (nonatomic, strong) UIImage *placeholerImg;

///是否无限播放, 暂时有bug, 等待修复
@property (nonatomic, assign) BOOL infiniteLoop;
///是否自动滚动, 默认为 YES
@property (nonatomic, assign) BOOL autoScroll;
///自动滚动间隔, 单位s, 默认2s
@property (nonatomic, assign) NSInteger autoScrollTimeInterval;


#pragma mark - Function
+ (instancetype)cycleScrollViewWithModelArr:(NSArray *)modelArr
                     currentDidClickedBlock:(JLCycleScrollDidClickedBlock)currentDidClickedBlock;

@end
