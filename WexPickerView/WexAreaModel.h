//
//  WexAreaModel.h
//  WexPickerView
//
//  Created by wex on 2017/8/11.
//  Copyright © 2017年 wex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol WexAreaModel;
@interface WexAreaModel : JSONModel

@property (nonatomic, strong) NSString *districtCode;
@property (nonatomic, strong) NSString *districtName;
@property (nonatomic, strong) NSString *districtLevel;
@property (nonatomic, strong) NSArray<WexAreaModel> *subAreas;

@end
