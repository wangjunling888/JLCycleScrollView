//
//  JLCycleScrollView.m
//  JLCycleScrollView
//
//  Created by 王俊岭 on 2017/3/15.
//  Copyright © 2017年 王俊岭. All rights reserved.
//

#import "JLCycleScrollView.h"
#import "JLCycleScrollCell.h"

#import "Masonry.h"
#import "UIView+WJLFrameExtension.h"


static NSString *cycleScrollCellReuseID = @"cycleScrollCellReuseID";

@interface JLCycleScrollView () <UICollectionViewDelegate, UICollectionViewDataSource>
//UI
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIImageView *placeholerImgview;
@property (nonatomic, strong) UIPageControl *pageControl;
//定时器
@property (nonatomic, weak) NSTimer *timer;

//循环的item数量
@property (nonatomic, assign) NSInteger itemCount;

//外界传入值
@property (nonatomic, copy) JLCycleScrollDidClickedBlock currentDidClickedBlock;
@end

@implementation JLCycleScrollView

+ (instancetype)cycleScrollViewWithModelArr:(NSArray *)modelArr
                     currentDidClickedBlock:(JLCycleScrollDidClickedBlock)currentDidClickedBlock {

    JLCycleScrollView *cycleScrollView = [[self alloc] init];
    
    cycleScrollView.currentDidClickedBlock = currentDidClickedBlock;
    cycleScrollView.dataArr = modelArr;
    return cycleScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self initData];
    }
    return self;
}
//初始化数据
- (void)initData {
    _autoScroll = YES;
    _infiniteLoop = YES;
    _autoScrollTimeInterval = 2.0;
    dispatch_async(dispatch_get_main_queue(), ^{// 异步方法可以等主线程不忙时再执行, 此时self.frame.size的值可以取到; 而且
        self.flowLayout.itemSize = self.frame.size;
        NSInteger item = 0;
        if (self.infiniteLoop) {
            item = self.itemCount *0.5;
        } else {
            item = 0;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
    });
    
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self insertSubview:self.placeholerImgview atIndex:0];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(@40);
        make.bottom.equalTo(self);
    }];
    [self.placeholerImgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Setter

- (void)setDataArr:(NSArray<JLCycleScrollModel *> *)dataArr {
    _dataArr = dataArr;
    
    [self invalidateTimer];
    if (self.infiniteLoop) {
         self.itemCount = _dataArr.count *2;
    } else {
        self.itemCount = _dataArr.count;
    }
    
    if (dataArr.count > 1) {
        self.collectionView.scrollEnabled = YES;
         self.pageControl.hidden = NO;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.collectionView.scrollEnabled = NO;
        self.pageControl.hidden = YES;
    }
    self.pageControl.numberOfPages = _dataArr.count;

}
//自动滚动
-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}
- (void)setPlaceholerImg:(UIImage *)placeholerImg {
    _placeholerImg = placeholerImg;
    self.placeholerImgview.image = placeholerImg;
}


#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[JLCycleScrollCell class] forCellWithReuseIdentifier:cycleScrollCellReuseID];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.itemSize = self.frame.size;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UIImageView *)placeholerImgview {
    if (_placeholerImgview == nil) {
        _placeholerImgview = [[UIImageView alloc] init];
    }
    return _placeholerImgview;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

#pragma mark - Private Function


//定时器
- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}
- (void)automaticScroll {
    if (self.autoScrollTimeInterval == 0) {
        return;
    }
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(NSInteger)targetIndex
{
    if (targetIndex >= self.itemCount) {
        if (self.infiniteLoop) {
            targetIndex = self.itemCount * 0.5;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (NSInteger)currentIndex
{
    if (self.collectionView.width == 0 || self.collectionView.height == 0) {
        return 0;
    }
    
    NSInteger index = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.collectionView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (self.collectionView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    
    return MAX(0, index);
}
- (NSInteger)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return index % self.dataArr.count;
}

#pragma mark - Collection DataSource and Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JLCycleScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cycleScrollCellReuseID forIndexPath:indexPath];
    cell.placeholderImg = self.placeholerImg;
    cell.model = self.dataArr[[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    JLCycleScrollModel *model = self.dataArr[index];
    if (self.currentDidClickedBlock) {
        self.currentDidClickedBlock(index, model);
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.dataArr.count == 0) {
        return;
    }
    NSInteger itemIndex = [self currentIndex];
    NSInteger indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
        self.pageControl.currentPage = indexOnPageControl;

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.dataArr.count == 0) {
        return;
    }
    NSInteger itemIndex = [self currentIndex];
    if (self.infiniteLoop) {
        if (itemIndex == 0 || itemIndex == ([self.collectionView numberOfItemsInSection:0] - 1)) {
            
            // 第 0 页，切换到 count 位置，最后一页，切换到 count - 1 的位置
            itemIndex = self.dataArr.count - (itemIndex == 0 ? 0 : 1);
            // 调整 offset
            scrollView.contentOffset = CGPointMake(itemIndex * scrollView.bounds.size.width, 0);
        }
    }
}

#pragma mark - System Function
- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
//    self.flowLayout.itemSize = self.frame.size;//设置collection的布局, 只有在这个地方才能拿到self.frame.size
    
//    if (self.collectionView.x == 0 && self.dataArr > 0) {
//        NSInteger item = 0;
//        if (self.infiniteLoop) {
//            item = self.itemCount *0.5;
//        } else {
//            item = 0;
//        }
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
//        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//    }
   
}


@end
