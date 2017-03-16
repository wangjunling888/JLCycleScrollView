//
//  JLCycleScrollCell.m
//  JLCycleScrollView
//
//  Created by 王俊岭 on 2017/3/15.
//  Copyright © 2017年 王俊岭. All rights reserved.
//

#import "JLCycleScrollCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"


#import "JLCycleScrollModel.h"

@interface JLCycleScrollCell ()
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation JLCycleScrollCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setModel:(JLCycleScrollModel *)model {
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.imgURL] placeholderImage:self.placeholderImg];
    
}
- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

@end
