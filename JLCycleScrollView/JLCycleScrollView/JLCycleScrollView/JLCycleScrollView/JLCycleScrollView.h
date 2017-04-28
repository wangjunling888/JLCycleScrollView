//
//  JLCycleScrollView.h
//  JLCycleScrollView
//
//  Created by 王俊岭 on 2017/3/15.
//  Copyright © 2017年 王俊岭. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^JLCycleScrollDidClickedBlock)(NSInteger index);


@interface JLCycleScrollView : UIView

@property (nonatomic, strong) NSArray *dataArr;//图片链接或名称数组

@property (nonatomic, strong) UIImage *placeholerImg;

///是否无限播放, 默认为 YES
@property (nonatomic, assign) BOOL infiniteLoop;
///是否自动滚动, 默认为 YES
@property (nonatomic, assign) BOOL autoScroll;
///自动滚动间隔, 单位s, 默认2s
@property (nonatomic, assign) NSInteger autoScrollTimeInterval;


/***************pageController样式设置*****************/
@property (nonatomic, strong) UIColor *currentPageColor;
@property (nonatomic, strong) UIColor *pageColor;

#pragma mark - Function


//如果有本地图片可以直接调用此方法将图片传入
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame
                               imagesArr:(NSArray *)modelArr
                  currentDidClickedBlock:(JLCycleScrollDidClickedBlock)currentDidClickedBlock;

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame
                  currentDidClickedBlock:(JLCycleScrollDidClickedBlock)currentDidClickedBlock;

@end
