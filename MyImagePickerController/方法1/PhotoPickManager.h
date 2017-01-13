//
//  PhotoPickManager.h
//  MyImagePickerController
//
//  Created by lyj on 17/1/11.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PickerType){
    PickerType_Camera = 0,// 拍照
    PickerType_Photo,// 相片
};

typedef void(^CallBackBlock)(NSDictionary *infoDict, BOOL isCancel); // 回调


@interface PhotoPickManager : NSObject

+ (instancetype)shareInstance; // 单例

- (void)presentPicker:(PickerType)pickerType target:(UIViewController *)vc callBackBlock:(CallBackBlock)callBackBlock;

@end
