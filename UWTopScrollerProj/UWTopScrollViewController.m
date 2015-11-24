//
//  UWTopScrollViewController.m
//  UWTopScrollerProj
//
//  Created by 王智超 on 15/11/23.
//  Copyright © 2015年 com.FengurDev. All rights reserved.
//

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#import "UWTopScrollViewController.h"
#import "UWTitleLabel.h"
#import "UWViewController.h"

#define NavHeight 64
#define TopScrollMenuH 40
@interface UWTopScrollViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *topScrollView;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, assign) CGFloat beginOffsetX;

@property (nonatomic, strong) NSMutableArray *arrayLists;

@property (nonatomic, strong) NSMutableArray *urlStringList;
@end

@implementation UWTopScrollViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"HelloWorld";
    [self setUpArray];
    [self setUpScrollViews];
    [self setUpChildControllers];
    [self setUpTitleLabels];
    [self setUpOriginData];
}

- (void)setUpOriginData {
    CGFloat mainScrollContentWidth = self.childViewControllers.count * ScreenWidth;
    self.mainScrollView.contentSize = CGSizeMake(mainScrollContentWidth, 0);
    self.mainScrollView.pagingEnabled = YES;

    UWViewController *vc = [self.childViewControllers firstObject];
    vc.urlString = [self.urlStringList firstObject];
    vc.view.frame = self.mainScrollView.bounds;
    [self.mainScrollView addSubview:vc.view];
    UWTitleLabel *lable = [self.topScrollView.subviews firstObject];
    lable.scale = 1.0;
    [super viewDidLoad];
}

- (void)setUpScrollViews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _topScrollView =
        [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, TopScrollMenuH)];
    [self.view addSubview:_topScrollView];
    _topScrollView.backgroundColor = [UIColor whiteColor];
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;

    _mainScrollView =
        [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight + TopScrollMenuH, ScreenWidth,
                                                       ScreenHeight - TopScrollMenuH - NavHeight)];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
}

- (void)setUpTitleLabels {
    CGFloat lblW = 70;
    CGFloat lblH = 40;
    CGFloat lblY = 0;
    CGFloat lblX = 0;
    for (int i = 0; i < self.arrayLists.count; i++) {
        lblX = i * lblW;
        UWTitleLabel *lbl1 = [[UWTitleLabel alloc] init];
        UIViewController *vc = self.childViewControllers[i];
        lbl1.text = vc.title;
        lbl1.frame = CGRectMake(lblX, lblY, lblW, lblH);
        lbl1.font = [UIFont fontWithName:@"HYQiHei" size:19];
        [self.topScrollView addSubview:lbl1];
        lbl1.tag = i;
        lbl1.userInteractionEnabled = YES;
        [lbl1 addGestureRecognizer:
                  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblClick:)]];
    }
    //设置小scroll滚动的范围
    self.topScrollView.contentSize = CGSizeMake(lblW * self.arrayLists.count, 0);
}

#pragma mark 标签栏的点击事件
- (void)lblClick:(UITapGestureRecognizer *)recognizer {
    UWTitleLabel *titlelable = (UWTitleLabel *)recognizer.view;

    CGFloat offsetX = titlelable.tag * self.mainScrollView.frame.size.width;

    CGFloat offsetY = self.mainScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);

    [self.mainScrollView setContentOffset:offset animated:YES];
}

#pragma mark - ******************** scrollView代理方法
/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView

{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.mainScrollView.frame.size.width;

    // 滚动标题栏
    UWTitleLabel *titleLable = (UWTitleLabel *)self.topScrollView.subviews[index];

    CGFloat offsetx = titleLable.center.x - self.topScrollView.frame.size.width * 0.5;

    CGFloat offsetMax = self.topScrollView.contentSize.width - self.topScrollView.frame.size.width;

    if (offsetx < 0) {
        offsetx = 0;
    } else if (offsetx > offsetMax) {
        offsetx = offsetMax;
    }

    CGPoint offset = CGPointMake(offsetx, self.topScrollView.contentOffset.y);
    [self.topScrollView setContentOffset:offset animated:YES];
    // 添加控制器
    UWViewController *newsVc = self.childViewControllers[index];
    newsVc.index = index;

    [self.topScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            UWTitleLabel *temlabel = self.topScrollView.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];

    if (newsVc.view.superview) return;

    newsVc.view.frame = scrollView.bounds;
    [self.mainScrollView addSubview:newsVc.view];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    UWTitleLabel *labelLeft = self.topScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.topScrollView.subviews.count) {
        UWTitleLabel *labelRight = self.topScrollView.subviews[rightIndex];

        labelRight.scale = scaleRight;
    }
}

- (void)setUpChildControllers {
    for (int i = 0; i < self.arrayLists.count; i++) {
        UWViewController *vc = [[UWViewController alloc] init];
        vc.urlString = self.urlStringList[i];
        vc.title = self.arrayLists[i];
        [self addChildViewController:vc];
    }
}
- (void)setUpArray {
    _arrayLists =
        [[NSMutableArray alloc] initWithObjects:@"百度", @"腾讯", @"cocoaChina", @"网易",
                                                @"搜狐", @"布衣书局", @"UI4App", nil];
    _urlStringList = [[NSMutableArray alloc]
        initWithObjects:@"https://www.baidu.com/", @"http://www.qq.com/",
                        @"http://www.cocoaChina.com/", @"http://www.163.com/",
                        @"http://www.sohu.com/", @"http://www.booyee.com.cn/",
                        @"http://www.ui4app.com/", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
