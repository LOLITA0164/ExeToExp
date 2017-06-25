//
//  WebCtrl.m
//  WZSW
//
//  Created by LOLITA on 17/3/27.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "WebCtrl.h"
#import <WebKit/WebKit.h>

@interface WebCtrl ()<WKUIDelegate,WKNavigationDelegate>

@property(strong,nonatomic)WKWebView *webView;

@end

@implementation WebCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}


/**
 初始化UI
 */
-(void)initUI{
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.needGoBackBtn = YES;
    [self.view addSubview:self.navBar];
    
    [self.view addSubview:self.webView];
    
}

//使用WKWebView不能加载除file,http及https开头的url(UIWebView可以)
//[NSString stringWithFormat:@"file://%@",[[self.webURL absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
-(WKWebView *)webView{
    if (_webView==nil) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavBar_HEIGHT, kScreenWidth, kScreenHeight-NavBar_HEIGHT)];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.allowsBackForwardNavigationGestures = YES;
//        [_webView goBack];
        NSURL *URL = [NSURL URLWithString:self.dataUrlString];
        [_webView loadRequest:[NSURLRequest requestWithURL:URL]];
    }
    return _webView;
}
#pragma mark - 代理
/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    DLog(@"开始加载");
    [self.hudView showIndicatorView];
}
/// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    DLog(@"获取到内容");
    [self.hudView hideIndicatorView];
}
/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    DLog(@"加载完成");
}
/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    DLog(@"加载失败");
    [self.hudView hideIndicatorView];
    [self.hudView showTip:@"加载失败" delay:kDelayTime];
}

/**
 返回事件
 */
-(void)goBackBtnAction{
    if (self.webView.canGoBack==YES) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}




-(void)dealloc{
    DLog(@"WebCtrl dealloc!!");
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
