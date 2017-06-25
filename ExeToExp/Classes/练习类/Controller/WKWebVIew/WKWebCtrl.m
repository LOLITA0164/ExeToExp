//
//  WKWebCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/13.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "WKWebCtrl.h"

#import <WebKit/WebKit.h>

@interface WKWebCtrl ()<WKUIDelegate,WKNavigationDelegate>

@property(strong,nonatomic)WKWebView *webView;

@property(strong,nonatomic)UIProgressView *progress;

@end

@implementation WKWebCtrl

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.webView.userInteractionEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}


/**
 初始化UI
 */
-(void)initUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    
    [self.view addSubview:self.progress];
    
    DLog(@"进度：%f",self.webView.estimatedProgress);
    
}


-(WKWebView *)webView{
    if (_webView==nil) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavBar_HEIGHT, kScreenWidth, kScreenHeight-NavBar_HEIGHT)];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.allowsBackForwardNavigationGestures = YES;
        [_webView goBack];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:self.dataUrlString]];
        [_webView loadRequest:request];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webView;
}


#pragma mark - navigationDelegate代理
/// 1
//在发送请求之前，决定是否继续处理。根据webView、navigationAction相关信息决定这次跳转
//是否可以继续进行,这些信息包含HTTP发送请求，如头部包含User-Agent,Accept。
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    DLog(@"捕获地址:%@",URL);
    self.navBar.title = [NSString stringWithFormat:@"捕获地址:%@",URL];
    decisionHandler(WKNavigationActionPolicyAllow);
}
/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载网页调用此方法
    DLog(@"页面加载");
    self.navBar.title = @"页面加载";
    self.webView.userInteractionEnabled = NO;
}
/// 3 在收到服务器的响应头，根据response相关信息，决定是否跳转。decisionHandler必须调用，来决定是否跳转，参数WKNavigationActionPolicyCancel取消跳转，WKNavigationActionPolicyAllow允许跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    self.navBar.title = @"response";
    decisionHandler(WKNavigationResponsePolicyAllow);
}
/// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    self.navBar.title = @"获取到内容";
    DLog(@"获取到内容");
}
/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    DLog(@"加载完成");
    self.navBar.title = @"加载完成";
    self.webView.userInteractionEnabled = YES;
    DLog(@"可返回的列表：%@",webView.backForwardList.backList);
}
/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    DLog(@"加载失败");
    self.navBar.title = @"加载失败";
    self.webView.userInteractionEnabled = YES;
}
/// 页面重定向
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    DLog(@"重定向");
    self.navBar.title = @"重定向";
}


///监听estimatedProgress
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.webView) {
            DLog(@"%f",self.webView.estimatedProgress);
            [self.progress setProgress:self.webView.estimatedProgress animated:YES];
            self.progress.progress = self.progress.progress==1?0:self.progress.progress;
            self.progress.hidden = self.progress.progress==1?YES:NO;
        }
        else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



-(UIProgressView *)progress{
    if (_progress==nil) {
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progress.trackTintColor = [UIColor clearColor];
        _progress.progressTintColor = [UIColor redColor];
        _progress.frame = CGRectMake(0, 64, kScreenWidth, 1);
    }
    return _progress;
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
    NSLog(@"WebCtrl dealloc!!");
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
