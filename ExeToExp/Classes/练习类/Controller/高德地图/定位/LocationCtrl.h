//
//  LocationCtrl.h
//  ExeToExp
//
//  Created by LOLITA on 17/3/28.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "BaseAMapCtrl.h"
/*
 在 Info.plist 文件中增加定位权限配置
 Privacy - Location Always Usage Description      --    始终允许访问位置信息        --  后台定位
 Privacy - Location Usage Description             --    永不允许访问位置信息
 Privacy - Location When In Use Usage Description --    使用应用期间允许访问位置信息  --  单次或持续定位
 */

@interface LocationCtrl : BaseAMapCtrl<AMapGeoFenceManagerDelegate>


@end
