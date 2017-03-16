//
//  JLCycleScrollCell.h
//  JLCycleScrollView
//
//  Created by 王俊岭 on 2017/3/15.
//  Copyright © 2017年 王俊岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLCycleScrollModel;

@interface JLCycleScrollCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *placeholderImg;
@property (nonatomic, strong) JLCycleScrollModel *model;

@end
