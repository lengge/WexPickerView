//
//  WexPickerViewConfiguration.h
//  CommonDemo
//
//  Created by wex on 2017/8/10.
//  Copyright © 2017年 wex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WexPickerViewDataItem.h"

typedef NS_ENUM(NSUInteger, WexPickerViewStyle) {
    WexPickerViewStyleSingle = 1, // 单联动
    WexPickerViewStyleDouble,     // 双联动
    WexPickerViewStyleThree       // 三联动
};

@interface WexPickerViewConfiguration : NSObject

@property (nonatomic, assign) WexPickerViewStyle pickerViewStyle;
// 一级数据
@property (nonatomic, strong) NSArray<WexPickerViewDataItem *> *dataArray;

@end
