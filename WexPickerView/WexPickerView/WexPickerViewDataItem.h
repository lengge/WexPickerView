//
//  WexPickerViewDataItem.h
//  CommonDemo
//
//  Created by wex on 2017/8/10.
//  Copyright © 2017年 wex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WexPickerViewDataItem : NSObject

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *des;

@property (nonatomic, strong) NSString *level;
// 下一级的数据，第二级、第三级...
@property (nonatomic, strong) NSArray<WexPickerViewDataItem *> *subArray;

@end
