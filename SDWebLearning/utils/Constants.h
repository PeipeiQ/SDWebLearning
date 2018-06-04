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

/** TabBaritem 宽度 */
#define kItemWidth kScreenWidth/5

/** 导航加状态栏高度 */
#define kNavBar_StatusBarHeight 64
/** 分割线高度 */
#define kSpliteHeight 0.5

/** 状态栏高度 */
#define kStatusBarHeight (IS_iPhoneX ? 44.f : 20.f)

/** 导航栏高度 */
#define kNavigationBarHeight  44.f

/** tabBar高度 */
#define kTabbarHeight (IS_iPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define kTabbarSafeBottomMargin        (IS_iPhoneX ? 34.f : 0.f)

// Status bar & navigation bar height.
#define kStatusBarAndNavigationBarHeight  (IS_iPhoneX ? 88.f : 64.f)

//判断是否iPhone X
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/*-------------------- 网络 -----------------------------*/
#define BaseUrl @"http://localhost"










#endif /* Constants_h */
