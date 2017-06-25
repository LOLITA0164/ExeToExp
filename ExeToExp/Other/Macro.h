//
//  Macro.h
//  ExeToExp
//
//  Created by LOLITA on 17/3/24.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#endif /* Macro_h */




//-------------------获取设备大小-------------------------
//NavBar高度
#define NavBar_HEIGHT 64

//获取屏幕 宽度、高度，支持横屏
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
#define kScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define kScreenSize ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenSize [UIScreen mainScreen].bounds.size
#define kScreenBounds [UIScreen mainScreen].bounds
#endif
//-------------------获取设备大小-------------------------




//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif
//-------------------打印日志-------------------------




//-------------------返回一个随机数-------------------------
#define RandomNumberFromAtoB(A,B) (int)(A+(arc4random()%(B-A+1)))
//-------------------返回一个随机数-------------------------




//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define ColorWithHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 获取RGB颜色
#define ColorWithRGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define ColorWithRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:79.0/255.0 green:166.0/255.0 blue:240.0/255.0 alpha:1.0]

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

//随机颜色
#define RandColor ColorWithRGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
//----------------------颜色类---------------------------






//----------------------字体尺寸类---------------------------
//极小
#define sizeTiny AdaptedSizeValue(9)
//小号
#define sizeSmall AdaptedSizeValue(12)
//普通
#define sizeNormal AdaptedSizeValue(15)
//大号
#define sizeBig AdaptedSizeValue(18)
//----------------------字体尺寸类---------------------------






//----------------------其他----------------------------
//弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


//以iPhone6为基准，获取缩放比例来设置控件的自适应
#define kScreenWidthRatio (kScreenWidth/375.0)
#define kScreenHeightRatio (kScreenHeight/667.0)
#define AdaptedWidthValue(x) (x*kScreenWidthRatio)
#define AdaptedHeightValue(x) (x*kScreenHeightRatio)
#define AdaptedSizeValue(x) (x*(kScreenWidthRatio+kScreenHeightRatio)/2.0)
//字体大小,自适应
#define MyFont(a) [UIFont systemFontOfSize:AdaptedFontSizeValue(a)]
#define MyBoldFont(b) [UIFont boldSystemFontOfSize:AdaptedFontSizeValue(b)]


//本地存储
#define UserDefaultSaveInfoForKey(__VALUE__,__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

//获得存储的对象
#define UserDefaultGetInfoForKey(__KEY__)  [[NSUserDefaults standardUserDefaults] objectForKey:__KEY__]

//删除对象
#define UserDefaultRemoveObjectForKey(__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

//告警框
#define Alert(title,msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]


//默认颜色
#define defaultSelectedColor ColorWithRGB(245,90,93)
#define defaultUnSelectedColor ColorWithRGB(85,85,85)
#define navBarColor ColorWithRGB(210,63,65)































#define kDelayTime 1.5



///单次定位
#define kOnceLocationDetailURL @"http://lbs.amap.com/api/ios-location-sdk/guide/get-location/singlelocation"
///持续定位
#define kSeriallocationDetailURL @"http://lbs.amap.com/api/ios-location-sdk/guide/get-location/seriallocation"
///后台定位
#define kBackgroundlocationDetailURL @"http://lbs.amap.com/api/ios-location-sdk/guide/get-location/backgroundlocation"
///绘制
#define kDrawUpPointURL @"http://lbs.amap.com/api/ios-sdk/guide/draw-on-map/draw-marker"
///POI搜索
#define kPOISearch @"http://lbs.amap.com/api/ios-sdk/guide/map-data/poi#keywords"


///URL Schemes
#define kURLSchemes @"http://www.jianshu.com/p/eed01a661186"



///应用跳转http://www.jianshu.com/p/b7ab3739c7b5
#define kAppSkipToAPP @"http://www.cocoachina.com/ios/20161026/17855.html"















