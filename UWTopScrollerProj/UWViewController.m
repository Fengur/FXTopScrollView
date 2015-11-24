//
//  UWViewController.m
//  UWTopScrollerProj
//
//  Created by 王智超 on 15/11/24.
//  Copyright © 2015年 com.FengurDev. All rights reserved.
//

#import "UWViewController.h"

@interface UWViewController ()
{
    UIWebView *uwWebView;
}
@end

@implementation UWViewController

- (void)viewDidLoad {
    uwWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 40)];
    uwWebView.scalesPageToFit = YES;
    [self.view addSubview:uwWebView];
    [uwWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
