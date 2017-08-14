//
//  WexPickerView.m
//  CommonDemo
//
//  Created by wex on 2017/8/10.
//  Copyright © 2017年 wex. All rights reserved.
//

#import "WexPickerView.h"
#import "UIView+Wex.h"

// 工具条
@interface WexPickerViewToolBar ()

@end

@implementation WexPickerViewToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self wex_setupSubviews];
    }
    return self;
}

- (void)wex_setupSubviews {
    UIButton *cancelButton = [self buttonWithTitle:@"取消" tag:KCancelButtonTag];
    cancelButton.left = 15.f;
    cancelButton.top = (self.height - cancelButton.height) / 2;
    UIButton *confirmButton = [self buttonWithTitle:@"确定" tag:KConfirmButtonTag];
    confirmButton.right = self.width - 15.f;
    confirmButton.top = (self.height - confirmButton.height) / 2;
    [self addSubview:cancelButton];
    [self addSubview:confirmButton];
}

- (UIButton *)buttonWithTitle:(NSString *)title tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTag:tag];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return button;
}

- (void)buttonClicked:(UIButton *)button {
    if (self.buttonClickedBlock) {
        self.buttonClickedBlock(button);
    }
}

@end

// 选择器
@interface WexPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) WexPickerViewConfiguration *configuration;

@property (nonatomic, strong) WexPickerViewToolBar *toolBar;

@property (nonatomic, strong) UIPickerView *pickerView;
// 一级数据
@property (nonatomic, strong) NSArray *firstArray;
// 二级数据
@property (nonatomic, strong) NSArray *secondArray;
// 三级数据
@property (nonatomic, strong) NSArray *thirdArray;

@end

@implementation WexPickerView

+ (instancetype)pickerViewWithConfiguration:(WexPickerViewConfiguration *)configuration {
    WexPickerView *pickerView = [[WexPickerView alloc] initWithConfiguration:configuration];
    return pickerView;
}

- (instancetype)initWithConfiguration:(WexPickerViewConfiguration *)configuration {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, KToolBarHeight + KPickerHeight + SCREEN_H)]) {
        _configuration = configuration;
        self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f];
        
        [self wex_initData];
        [self wex_setupSubviews];
    }
    return self;
}

- (void)wex_initData {
    if (_configuration.pickerViewStyle == WexPickerViewStyleSingle) {
        _firstArray = _configuration.dataArray;
    } else if (_configuration.pickerViewStyle == WexPickerViewStyleDouble) {
        _firstArray = _configuration.dataArray;
        
        if (!_configuration.dataArray.count) return;
        WexPickerViewDataItem *item = [_configuration.dataArray firstObject];
        _secondArray = item.subArray;
    } else if (_configuration.pickerViewStyle == WexPickerViewStyleThree) {
        _firstArray = _configuration.dataArray;
        
        if (!_configuration.dataArray.count) return;
        WexPickerViewDataItem *item = [_configuration.dataArray firstObject];
        _secondArray = item.subArray;
        
        if (!_secondArray.count) return;
        item = [_secondArray firstObject];
        _thirdArray = item.subArray;
    }
}

- (void)wex_setupSubviews {
    @weakify(self);
    self.toolBar.buttonClickedBlock = ^(UIButton *button) {
        if (button.tag == KCancelButtonTag) {
            [weak_self dismiss];
        } else if (button.tag == KConfirmButtonTag) {
            [weak_self confirm];
        }
    };
    [self addSubview:self.toolBar];
    [self addSubview:self.pickerView];
}

- (void)dismiss {
    [self hide];
}

- (void)confirm {
    [self hide];
    if (_configuration.pickerViewStyle == WexPickerViewStyleSingle) {
        NSInteger firstRow = [_pickerView selectedRowInComponent:0];
        
        WexPickerViewDataItem *firstItem = firstRow < _firstArray.count ? _firstArray[firstRow] : nil;
        
        NSString *stringValue = [NSString stringWithFormat:@"%@", firstItem != nil ? firstItem.des : @""];
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:selectedStringValue:)]) {
            [self.delegate pickerView:self selectedStringValue:stringValue];
        }
    } else if (_configuration.pickerViewStyle == WexPickerViewStyleDouble) {
        NSInteger firstRow = [_pickerView selectedRowInComponent:0];
        NSInteger secondRow = [_pickerView selectedRowInComponent:1];
        
        WexPickerViewDataItem *firstItem = firstRow < _firstArray.count ? _firstArray[firstRow] : nil;
        WexPickerViewDataItem *secondItem = secondRow < _secondArray.count ? _secondArray[secondRow] : nil;
        
        NSString *stringValue = [NSString stringWithFormat:@"%@-%@", firstItem != nil ? firstItem.des : @"", secondItem != nil ? secondItem.des : @""];
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:selectedStringValue:)]) {
            [self.delegate pickerView:self selectedStringValue:stringValue];
        }
    } else if (_configuration.pickerViewStyle == WexPickerViewStyleThree) {
        NSInteger firstRow = [_pickerView selectedRowInComponent:0];
        NSInteger secondRow = [_pickerView selectedRowInComponent:1];
        NSInteger thirdRow = [_pickerView selectedRowInComponent:2];
        
        WexPickerViewDataItem *firstItem = firstRow < _firstArray.count ? _firstArray[firstRow] : nil;
        WexPickerViewDataItem *secondItem = secondRow < _secondArray.count ? _secondArray[secondRow] : nil;
        WexPickerViewDataItem *thirdItem = thirdRow < _thirdArray.count ? _thirdArray[thirdRow] : nil;
        
        NSString *stringValue = [NSString stringWithFormat:@"%@-%@-%@", firstItem != nil ? firstItem.des : @"", secondItem != nil ? secondItem.des : @"", thirdItem != nil ? thirdItem.des : @""];
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:selectedStringValue:)]) {
            [self.delegate pickerView:self selectedStringValue:stringValue];
        }
    }
}

- (void)show {
    [kKeyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.top = -(KToolBarHeight + KPickerHeight);
        self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.top = 0.f;
        self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_configuration.pickerViewStyle == WexPickerViewStyleSingle) {
        return 1;
    } else if (_configuration.pickerViewStyle == WexPickerViewStyleDouble) {
        return 2;
    } else if (_configuration.pickerViewStyle == WexPickerViewStyleThree) {
        return 3;
    } else {
        return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_configuration.pickerViewStyle == WexPickerViewStyleSingle) {
        return _firstArray.count;
    } else if (_configuration.pickerViewStyle == WexPickerViewStyleDouble) {
        if (component == 0) {
            return _firstArray.count;
        } else {
            return _secondArray.count;
        }
    } else if (_configuration.pickerViewStyle == WexPickerViewStyleThree) {
        if (component == 0) {
            return _firstArray.count;
        } else if (component == 1) {
            return _secondArray.count;
        } else {
            return _thirdArray.count;
        }
    } else {
        return 0;
    }
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_configuration.pickerViewStyle == WexPickerViewStyleSingle) {
        WexPickerViewDataItem *item = [_firstArray objectAtIndex:row];
        return item.des;
    } else if (_configuration.pickerViewStyle == WexPickerViewStyleDouble) {
        if (component == 0) {
            WexPickerViewDataItem *item = [_firstArray objectAtIndex:row];
            return item.des;
        } else {
            WexPickerViewDataItem *item = [_secondArray objectAtIndex:row];
            return item.des;
        }
    } else if (_configuration.pickerViewStyle == WexPickerViewStyleThree) {
        if (component == 0) {
            WexPickerViewDataItem *item = [_firstArray objectAtIndex:row];
            return item.des;
        } else if (component == 1) {
            WexPickerViewDataItem *item = [_secondArray objectAtIndex:row];
            return item.des;
        } else {
            WexPickerViewDataItem *item = [_thirdArray objectAtIndex:row];
            return item.des;
        }
    } else {
        return nil;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [UILabel new];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:15.f];
    }
    
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_configuration.pickerViewStyle == WexPickerViewStyleSingle) {
        
    } else if (_configuration.pickerViewStyle == WexPickerViewStyleDouble) {
        if (component == 0) {
            // 滚动第一列时，刷新第二列
            WexPickerViewDataItem *item = [_firstArray objectAtIndex:row];
            _secondArray = item.subArray;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
    } else if (_configuration.pickerViewStyle == WexPickerViewStyleThree) {
        if (component == 0) {
            // 滚动第一列时，刷新第二列和第三列
            WexPickerViewDataItem *item = [_firstArray objectAtIndex:row];
            _secondArray = item.subArray;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            if (_secondArray.count) {
                item = [_secondArray firstObject];
                _thirdArray = item.subArray;
            } else {
                _thirdArray = [NSArray array];
            }
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        } else if (component == 1) {
            // 滚动第二列时，刷新第三列
            WexPickerViewDataItem *item = [_secondArray objectAtIndex:row];
            _thirdArray = item.subArray;
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
    }
}

#pragma mark - getter
- (WexPickerViewToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[WexPickerViewToolBar alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, KToolBarHeight)];
    }
    return _toolBar;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, KToolBarHeight + SCREEN_H, SCREEN_W, KPickerHeight)];
        _pickerView.backgroundColor = KPickerBackColor;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

@end
