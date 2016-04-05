//
//  MethodDetailViewController.m
//  MVCTest
//
//  Created by 乐业天空 on 16/1/6.
//  Copyright © 2016年 myjobsky. All rights reserved.
//

#import "MethodDetailViewController.h"

@interface MethodDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MethodDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    if (self.type == 0)
    {
        [self.webView loadHTMLString:self.string baseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    }
    else
    {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.string]];
        [self.webView loadRequest:request];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

@end
