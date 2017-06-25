//
//  MyTabBarCtrl.m
//  ExeToExp
//
//  Created by LOLITA on 17/3/24.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "MyTabBarCtrl.h"
#import "TableListCtrl.h"

@interface MyTabBarCtrl ()

@property(strong,nonatomic)NSMutableArray *navs;

@end

@implementation MyTabBarCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

/**
 初始化视图
 */
-(void)initUI{
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSString *moduleName = nil;
    
    //实用工具类
    {
        TableListCtrl *ctrl = [[TableListCtrl alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        moduleName = [AppTool sharedInstance].RESULT.TOOLS.MODULENAME;
        UITabBarItem *barItem = [self makeItemWithTitle:moduleName normalImage:@"toolUnSelect" selectedImage:@"toolSelect" tag:0];
        ctrl.navBar.title = moduleName;
        ctrl.data = [AppTool sharedInstance].RESULT.TOOLS.MODULENODES;
        nav.tabBarItem = barItem;
        [self.navs addObject:nav];
    }
    
    
    //技巧类
    {
        TableListCtrl *ctrl = [[TableListCtrl alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        moduleName = [AppTool sharedInstance].RESULT.SKILLS.MODULENAME;
        UITabBarItem *barItem = [self makeItemWithTitle:moduleName normalImage:@"skillUnSelect" selectedImage:@"skillSelect" tag:1];
        ctrl.navBar.title = moduleName;
        ctrl.data = [AppTool sharedInstance].RESULT.SKILLS.MODULENODES;
        nav.tabBarItem = barItem;
        [self.navs addObject:nav];
    }
    
    
    //练习类
    {
        TableListCtrl *ctrl = [[TableListCtrl alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        moduleName = [AppTool sharedInstance].RESULT.EXERCISE.MODULENAME;
        UITabBarItem *barItem = [self makeItemWithTitle:moduleName normalImage:@"exeUnSelect" selectedImage:@"exeSelect" tag:2];
        ctrl.navBar.title = moduleName;
        ctrl.data = [AppTool sharedInstance].RESULT.EXERCISE.MODULENODES;
        nav.tabBarItem = barItem;
        [self.navs addObject:nav];
    }
    
    
    //心得体会
    {
        TableListCtrl *ctrl = [[TableListCtrl alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        moduleName = [AppTool sharedInstance].RESULT.EXPERIENCE.MODULENAME;
        UITabBarItem *barItem = [self makeItemWithTitle:moduleName normalImage:@"expUnSelect" selectedImage:@"expSelect" tag:3];
        ctrl.navBar.title = moduleName;
        ctrl.data = [AppTool sharedInstance].RESULT.EXPERIENCE.MODULENODES;
        nav.tabBarItem = barItem;
        [self.navs addObject:nav];
    }
    
    self.viewControllers = self.navs;
    self.tabBar.backgroundColor = [UIColor whiteColor];
}



- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    DLog(@"item tag = %ld", item.tag);
}



#pragma mark - 获取barItem
-(UITabBarItem*)makeItemWithTitle:(NSString*)title normalImage:(NSString *)normal selectedImage:(NSString *)selected tag:(NSInteger)tag{
    
    UITabBarItem *tabBarItem = nil;
    
    UIImage *normalImage = [[UIImage imageNamed:normal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >=7.0) {
        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    }
    else{
        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage tag:tag];
    }
    
    tabBarItem.tag = tag;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:sizeSmall],NSForegroundColorAttributeName:defaultSelectedColor} forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:sizeSmall],NSForegroundColorAttributeName:defaultUnSelectedColor} forState:UIControlStateNormal];
    
    return tabBarItem;
}


/**
 navBar数组

 @return nil
 */
-(NSMutableArray *)navs{
    if (_navs==nil) {
        _navs = [NSMutableArray array];
    }
    return _navs;
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
