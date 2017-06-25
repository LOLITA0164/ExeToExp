//
//  POPCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/4/19.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "POPCtrl.h"

@interface POPCtrl ()<POPAnimationDelegate>

@property(nonatomic) UIControl *dragView;

@end

@implementation POPCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
}


-(void)initData{
    
    self.needDetailBtn = YES;
    
    if ([self.moduleCode isEqualToString:@"pop_spring"]) {//自定义动画
        [self pop_spring];
    }
    else if ([self.moduleCode isEqualToString:@"pop_decay"]){//衰减动画
        [self pop_decay];
    }
    else if ([self.moduleCode isEqualToString:@"pop_basic"]){//基础动画
        [self pop_basic];
    }
    else if ([self.moduleCode isEqualToString:@"pop_custom"]){//自定义动画
        [self pop_custom];
    }
    else if ([self.moduleCode isEqualToString:@"pop_exe"]){//练习
        [self pop_exe];
    }
    
}









/**
 弹簧动画
 */
-(void)pop_spring{
    CALayer *layer        = [CALayer layer];
    layer.frame           = CGRectMake(0, 0, 50, 50);
    layer.position        = self.view.center;
    layer.backgroundColor = RandColor.CGColor;
    layer.cornerRadius    = layer.frame.size.height/2.0;
    [self.view.layer addSublayer:layer];

    //添加动画
    POPSpringAnimation *ani = [POPSpringAnimation animation];
    ani.property            = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
    ani.toValue             = [NSValue valueWithCGPoint:CGPointMake(2.f, 2.f)];//最终值大小(toValue)
    ani.springSpeed         = 0.f;//速度
    ani.springBounciness    = 20;//弹性,值越大，震荡次数越多
    ani.delegate            = self;
    [layer pop_addAnimation:ani forKey:nil];
    
    
    
    UIView *view       = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-25, 150, 50, 50)];
    view.backgroundColor = RandColor;
    [self.view addSubview:view];
    POPSpringAnimation *ani2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleX];
    ani2.toValue             = [NSValue valueWithCGPoint:CGPointMake(2.0f, 1.0f)];
    ani2.springSpeed         = 0.f;//速度
    ani2.springBounciness    = 20;//弹性,值越大，震荡次数越多
    [view.layer pop_addAnimation:ani2 forKey:nil];
    
    
    
    UIButton *btn2           = [[UIButton alloc] initWithFrame:CGRectMake(10, 64+10, 50, 50)];
    btn2.backgroundColor     = RandColor;
    [self.view addSubview:btn2];
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.toValue             = [NSValue valueWithCGPoint:CGPointMake(btn2.centerX, kScreenHeight/2.0)];
    anim.springSpeed         = 0;//速度
    anim.springBounciness    = 1;//弹性,值越大，震荡次数越多
//    anim.dynamicsTension     = 50.0;//张力
//    anim.dynamicsFriction    = 5.0;//摩擦力
//    anim.dynamicsMass        = 2.0;//质量
    [btn2 pop_addAnimation:anim forKey:nil];
    
    
    
    UIView *view2             = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-25, self.view.centerY+150, 50, 50)];
    view2.backgroundColor     = RandColor;
    [self.view addSubview:view2];
    POPSpringAnimation *anim2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim2.toValue             = @(view2.centerX-50);
    anim2.velocity            = @200;
    anim2.springBounciness    = 20;
    [view2.layer pop_addAnimation:anim2 forKey:@"positionAnimation"];
    
}











/**
 衰减动画
 */
-(void)pop_decay{
    // 初始化dragView
    self.dragView                    = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.dragView.center             = self.view.center;
    self.dragView.layer.cornerRadius = CGRectGetWidth(self.dragView.bounds)/2;
    self.dragView.backgroundColor    = [UIColor cyanColor];
    [self.view addSubview:self.dragView];
    [self.dragView addTarget:self
                      action:@selector(touchDown:)
            forControlEvents:UIControlEventTouchDown];
    // 添加手势
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    [self.dragView addGestureRecognizer:recognizer];
    
    
    //例子2
    {
        CALayer *layer        = [CALayer layer];
        layer.frame           = CGRectMake(self.view.centerX-25, 150, 50, 50);
        layer.backgroundColor = RandColor.CGColor;
        layer.cornerRadius    = layer.frame.size.height/2.0;
        [self.view.layer addSublayer:layer];
        POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        anim.velocity = @(1000.);
//        [layer pop_addAnimation:anim forKey:@"slide"];
    }
    
    
}
- (void)touchDown:(UIControl *)sender {
    [sender.layer pop_removeAllAnimations];
}
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    // 拖拽
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    // 拖拽动作结束
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        // 计算出移动的速度
        CGPoint velocity = [recognizer velocityInView:self.view];
        // 衰退减速动画
        POPDecayAnimation *positionAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        // 设置代理
        positionAnimation.delegate = self;
        // 设置速度动画
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        // 设置衰减率
        positionAnimation.deceleration = 0.995;
        // 添加动画
        [recognizer.view.layer pop_addAnimation:positionAnimation
                                         forKey:nil];
    }
}










/**
 基础动画
 */
-(void)pop_basic{
    // 创建view
    UIView *showView            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    showView.alpha              = 0.f;
    showView.layer.cornerRadius = 50.f;
    showView.center             = self.view.center;
    showView.backgroundColor    = [UIColor cyanColor];
    [self.view addSubview:showView];
    
    //设置基本动画效果    透明度
    POPBasicAnimation *anim = [POPBasicAnimation defaultAnimation];
    anim.property           = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    anim.fromValue          = @(0);
    anim.toValue            = @(1);
    anim.duration           = 3.0;
    [showView pop_addAnimation:anim forKey:nil];
    
    
    UIView *view       = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-25, 150, 50, 50)];
    view.backgroundColor = RandColor;
    [self.view addSubview:view];
    POPBasicAnimation *anim2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim2.toValue             = [NSValue valueWithCGPoint:CGPointMake(3.0f, 1.0f)];
    anim2.duration           = 2.0;
    [view.layer pop_addAnimation:anim2 forKey:nil];
    
    
    UIButton *btn2            = [[UIButton alloc] initWithFrame:CGRectMake(10, 64+10, 50, 50)];
    btn2.backgroundColor      = RandColor;
    [self.view addSubview:btn2];
    POPBasicAnimation *anim3 = [POPBasicAnimation easeInEaseOutAnimation];
    anim3.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    anim3.toValue             = [NSValue valueWithCGPoint:CGPointMake(btn2.centerX, kScreenHeight/2.0)];
    anim3.duration           = 1.0;
    [btn2 pop_addAnimation:anim3 forKey:nil];
    
}








/**
 自定义动画
 */
-(void)pop_custom{
//    POPCustomAnimation *anim = [POPCustomAnimation ];
}










/**
 练习
 */
-(void)pop_exe
{
    
    NSUInteger count = 9;
    NSUInteger maxCols = 3;
    CGFloat buttonW = 50;
    CGFloat buttonH = 50;
    CGFloat buttonStartX = 30;
    CGFloat buttonStartY = (kScreenWidth-2*buttonH)*0.5;
    CGFloat buttonMargin = (kScreenWidth-2*buttonStartX-buttonW*maxCols)/(maxCols-1);
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = RandColor;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        //计算frame
        NSUInteger row = i/maxCols;
        NSUInteger col = i%maxCols;
        CGFloat buttonX = buttonStartX + col*(buttonW+buttonMargin);
        CGFloat buttonY = buttonStartY + row*(buttonH+30);
        //使用pop框架，改变frame往下掉,而且不需要再设置frame了，因为pop改变了frame
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY-kScreenWidth, buttonW, buttonH)];
        anim.toValue   = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        anim.springBounciness = 8;
        anim.springSpeed = 8;
        anim.beginTime = CACurrentMediaTime()+0.1*i;
        [button pop_addAnimation:anim forKey:nil];
    }
    
    
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    cancelBtn.center = CGPointMake(self.view.center.x, self.view.center.y+100);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = RandColor.CGColor;
    cancelBtn.layer.borderWidth = 1;
    [cancelBtn setTitleColor:RandColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

-(void)cancelAction{
    //让按钮往下掉
    NSUInteger index = 2;
    NSUInteger count = self.view.subviews.count;
    
    for (NSUInteger i = index; i<count ; i++) {
        UIView *subview = self.view.subviews[i];
        //这里不需要计算frame，因为已经添加到view中，只需要设置最后的位置
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        anim.toValue  = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, subview.centerY+kScreenHeight)];
        anim.beginTime = CACurrentMediaTime()+0.1*i;
        [subview pop_addAnimation:anim forKey:nil];
        if (i == count-1) {
            //最后一个控件pop完退出控制器，写在外面会直接退出
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                DLog(@"动作完成");
            }];
        }
    }
}
-(void)btnClick:(UIButton*)sender
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.toValue  = [NSValue valueWithCGPoint:CGPointMake(sender.centerX, sender.centerY+kScreenHeight)];
    anim.beginTime = CACurrentMediaTime()+0.1;
    [sender pop_addAnimation:anim forKey:nil];
    
}














#pragma mark - POPAnimationDelegate动画代理
-(void)pop_animationDidStart:(POPAnimation *)anim
{
    DLog(@"动画开始...");
}
-(void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    DLog(@"动画结束...");
}
- (void)pop_animationDidReachToValue:(POPAnimation *)anim
{
    DLog(@"动画到达指定值...");
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
