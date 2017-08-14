//
//  WexPickerView.h
//  CommonDemo
//
//  Created by wex on 2017/8/10.
//  Copyright © 2017年 wex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WexPickerViewConfiguration.h"
#import "WexPickerViewMacro.h"
#import "UIView+Wex.h"

// 工具条
@interface WexPickerViewToolBar : UIView

@property (nonatomic, copy) void(^buttonClickedBlock)(UIButton *button);

@end

@class WexPickerView;
@protocol WexPickerViewDelegate <NSObject>

@optional
- (void)pickerView:(WexPickerView *)pickerView selectedStringValue:(NSString *)stringValue;

@end

// 选择器
@interface WexPickerView : UIView

@property (nonatomic, weak) id<WexPickerViewDelegate> delegate;

// 通过配置初始化，配置必传
+ (instancetype)pickerViewWithConfiguration:(WexPickerViewConfiguration *)configuration;

- (void)show;

- (void)hide;

@end
