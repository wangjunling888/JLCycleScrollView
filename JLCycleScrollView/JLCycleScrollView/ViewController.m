//
//  ViewController.m
//  JLCycleScrollView
//
//  Created by 王俊岭 on 2017/3/15.
//  Copyright © 2017年 王俊岭. All rights reserved.
//

#import "ViewController.h"

#import "JLCycleScrollView.h"
#import "JLCycleScrollModel.h"


#import "Masonry.h"

@interface ViewController ()
@property (nonatomic, strong) JLCycleScrollView *bannerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(180);
    }];
    JLCycleScrollModel *model1 = [[JLCycleScrollModel alloc] init];
    model1.imgURL = @"https://cdn.pixabay.com/photo/2016/02/07/19/50/snow-1185474_1280.jpg";
    JLCycleScrollModel *model2 = [[JLCycleScrollModel alloc] init];
    model2.imgURL = @"https://cdn.pixabay.com/photo/2015/08/25/22/38/bridge-907812_1280.jpg";
    
    self.bannerView.dataArr = @[model1, model2];
    //self.bannerView.dataArr = nil;//测试placeholerImg是否可用;
    
}


- (JLCycleScrollView *)bannerView {
    if (_bannerView == nil) {
        _bannerView = [JLCycleScrollView cycleScrollViewWithModelArr:nil currentDidClickedBlock:^(NSInteger index, JLCycleScrollModel *model) {
            NSLog(@"%zd",index);
        }];
        _bannerView.placeholerImg = [UIImage imageNamed:@"arctic-139395_1280.jpg"];
        _bannerView.infiniteLoop = NO;
//        _bannerView.autoScroll = NO;
    }
    return _bannerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
