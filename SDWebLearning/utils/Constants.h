//
//  Constants.h
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/9.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

/*-------------------- 屏幕适配 -----------------------------*/
/** 屏幕高度 */
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
/** 高度比例 */
#define kScreen_H_Scale (kScreenHeight*1.0/667)
/** 宽度比例 */
#define kScreen_W_Scale (kScreenWidth/375)
/** 导航高度 */
#define kNavBarHeight 44
/** tabBar高度 */
#define kTabBarHeight 49
/** TabBaritem 宽度 */
#define kItemWidth kScreenWidth/5
/** 状态栏高度 */
#define kStatusBarHeight 20
/** 导航加状态栏高度 */
#define kNavBar_StatusBarHeight 64
/** 分割线高度 */
#define kSpliteHeight 0.5

#endif /* Constants_h */
