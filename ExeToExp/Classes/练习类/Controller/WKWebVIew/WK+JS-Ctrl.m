//
//  WK+JS-Ctrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/19.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "WK+JS-Ctrl.h"
#import <WebKit/WebKit.h>

@interface WK_JS_Ctrl ()<WKScriptMessageHandler>

@property(strong,nonatomic)WKWebView *webView;

@end

@implementation WK_JS_Ctrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    //JS调用OC   添加处理脚本
    {
        WKUserContentController *userCtrl = self.webView.configuration.userContentController;
        [userCtrl addScriptMessageHandler:self name:@"showMobile"];
        [userCtrl addScriptMessageHandler:self name:@"showName"];
        [userCtrl addScriptMessageHandler:self name:@"showSendMsg"];
    }
    
    
    //原生控件调用JS
    {
        NSArray *titles = @[@"小黄的手机号",@"打电话给小黄",@"给小黄发短信",@"清除"];
        for (int i=0; i<4; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.webView.bottom+10*(i+1)+((kScreenHeight/2.0)*0.8/5.0)*i, kScreenWidth, (kScreenHeight/2.0)*0.8/5.0)];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = RandColor;
            [self.view addSubview:btn];
        }
    }
    
    
}



-(WKWebView *)webView{
    if (_webView==nil) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavBar_HEIGHT, kScreenWidth, (kScreenHeight-NavBar_HEIGHT)/2.0)];
        _webView.backgroundColor = [UIColor clearColor];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
        NSURL *baseURL = [[NSBundle mainBundle] bundleURL];
        [_webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
    }
    return _webView;
}

#pragma mark - WKScriptMessageHandler必须实现
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"message.body(传递的消息):%@",message.body);
    NSLog(@"message.name:%@",message.name);
    if ([message.name isEqualToString:@"showMobile"]) {
        [self showMsg:@"我是下面的小红 手机号是:18870707070"];
    }
    else if ([message.name isEqualToString:@"showName"]) {
        NSString *info = [NSString stringWithFormat:@"你好 %@, 很高兴见到你",message.body];
        [self showMsg:info];
    }
    else if ([message.name isEqualToString:@"showSendMsg"]) {
        NSArray *array = message.body;
        NSString *info = [NSString stringWithFormat:@"这是我的手机号: %@, %@ !!",array.firstObject,array.lastObject];
        [self showMsg:info];
    }
}










//原生控件调用JS事件
//网页加载完成之后调用JS代码才会执行，因为这个时候html页面已经注入到webView中并且可以响应到对应方法
-(void)btnAction:(UIButton*)sender{
    
    if (!self.webView.loading) {
        if (sender.tag == 0) {
            [self.webView evaluateJavaScript:@"alertMobile()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                //TODO
                NSLog(@"%@ %@",response,error);
            }];
        }
        
        else if (sender.tag == 1) {
            [self.webView evaluateJavaScript:@"alertName('小红')" completionHandler:nil];
        }
        
        else if (sender.tag == 2) {
            [self.webView evaluateJavaScript:@"alertSendMsg('18870707070','周末爬山真是件愉快的事情')" completionHandler:nil];
        }
        
        else if (sender.tag == 3) {
            [self.webView evaluateJavaScript:@"clear()" completionHandler:nil];
        }
        
    } else {
        NSLog(@"the view is currently loading content");
    }
    
    
}




- (void)showMsg:(NSString *)msg {
    [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
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
