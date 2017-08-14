//
//  WexPickerViewMacro.h
//  CommonDemo
//
//  Created by wex on 2017/8/10.
//  Copyright © 2017年 wex. All rights reserved.
//

#ifndef WexPickerViewMacro_h
#define WexPickerViewMacro_h

#define HEIGHT_STATUSBAR	20

#define HEIGHT_TABBAR       49

#define HEIGHT_NAVBAR       44

#define KToolBarHeight     (44)

#define KPickerHeight      (200)

#define KCancelButtonTag   (-99)

#define KConfirmButtonTag  (99)

#define KPickerBackColor ([UIColor colorWithRed:240 / 255.0 green:239 / 255.0 blue: 245 / 255.0 alpha:1])

#define SCREEN_W      ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_H      ([UIScreen mainScreen].bounds.size.height)

#define SCREEN_WIDTH  (SCREEN_W < SCREEN_H ? SCREEN_W : SCREEN_H)

#define SCREEN_HEIGHT (SCREEN_W < SCREEN_H ? SCREEN_H : SCREEN_W)

#define kKeyWindow          [UIApplication sharedApplication].keyWindow

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

// 查看一段代码的执行时间
#define TICK  (NSDate *startTime = [NSDate date])
#define TOCK  (NSLog(@"Time: %f", -[startTime timeIntervalSinceNow]))

#endif /* WexPickerViewMacro_h */
