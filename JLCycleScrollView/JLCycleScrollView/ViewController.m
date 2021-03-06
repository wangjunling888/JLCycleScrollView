//
//  ViewController.m
//  JLCycleScrollView
//
//  Created by 王俊岭 on 2017/3/15.
//  Copyright © 2017年 王俊岭. All rights reserved.
//

#import "ViewController.h"

#import "JLCycleScrollView.h"


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

    self.bannerView.currentPageColor = [UIColor blueColor];
    self.bannerView.dataArr = @[@"https://cdn.pixabay.com/photo/2016/02/07/19/50/snow-1185474_1280.jpg",  @"arctic-139395_1280.jpg"];
    self.bannerView.autoScrollTimeInterval = 5;
    //self.bannerView.dataArr = nil;//测试placeholerImg是否可用;
    
}


- (JLCycleScrollView *)bannerView {
    if (_bannerView == nil) {
        _bannerView = [JLCycleScrollView cycleScrollViewWithModelArr:nil currentDidClickedBlock:^(NSInteger index) {
            NSLog(@"%zd",index);
        }];
        _bannerView.placeholerImg = [UIImage imageNamed:@"arctic-139395_1280.jpg"];
       // _bannerView.infiniteLoop = NO;
//        _bannerView.autoScroll = NO;
    }
    return _bannerView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
