//
//  ViewController.m
//  WexPickerView
//
//  Created by wex on 2017/8/11.
//  Copyright © 2017年 wex. All rights reserved.
//

#import "ViewController.h"
#import "WexPickerView.h"
#import "WexAreaModel.h"
#import "JSONModel.h"

@interface ViewController ()<WexPickerViewDelegate>

@property (nonatomic, strong) WexPickerView *pickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"show" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    
    WexPickerViewConfiguration *configuration = [[WexPickerViewConfiguration alloc] init];
    configuration.pickerViewStyle = WexPickerViewStyleThree;
    configuration.dataArray = [self loadData];
    _pickerView = [WexPickerView pickerViewWithConfiguration:configuration];
    _pickerView.delegate = self;
}


- (NSArray *)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];
    NSArray *dataArray = [WexAreaModel arrayOfModelsFromDictionaries:dic[@"body"][@"data"]];
    
    return [self convertArray:dataArray];
}

- (NSArray *)convertArray:(NSArray *)tmpArray {
    NSMutableArray *dataArray = [NSMutableArray array];
    for (WexAreaModel *componentOneItem in tmpArray) {
        // 省
        WexPickerViewDataItem *item = [[WexPickerViewDataItem alloc] init];
        item.code = componentOneItem.districtCode;
        item.des = componentOneItem.districtName;
        item.level = componentOneItem.districtLevel;
        if (componentOneItem.subAreas.count) {
            NSMutableArray *subAreas = [NSMutableArray array];
            for (WexAreaModel *componentTwoItem in componentOneItem.subAreas) {
                // 市
                WexPickerViewDataItem *item = [[WexPickerViewDataItem alloc] init];
                item.code = componentTwoItem.districtCode;
                item.des = componentTwoItem.districtName;
                item.level = componentTwoItem.districtLevel;
                if (componentTwoItem.subAreas.count) {
                    NSMutableArray *subAreas = [NSMutableArray array];
                    for (WexAreaModel *componentThreeItem in componentTwoItem.subAreas) {
                        // 区
                        WexPickerViewDataItem *item = [[WexPickerViewDataItem alloc] init];
                        item.code = componentThreeItem.districtCode;
                        item.des = componentThreeItem.districtName;
                        item.level = componentThreeItem.districtLevel;
                        [subAreas addObject:item];
                    }
                    item.subArray = subAreas;
                }
                [subAreas addObject:item];
            }
            item.subArray = subAreas;
        }
        [dataArray addObject:item];
    }
    
    return dataArray;
}

- (void)clickAction:(UIButton *)button {
    [_pickerView show];
}
#pragma mark - WexPickerViewDelegate
- (void)pickerView:(WexPickerView *)pickerView selectedStringValue:(NSString *)stringValue {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择了" message:stringValue preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
