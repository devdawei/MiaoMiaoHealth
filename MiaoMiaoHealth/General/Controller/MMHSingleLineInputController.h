//
//  MMHSingleLineInputController.h
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/31.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MMHInputType)
{
    /** 输入的类型为 NSUInteger */
    MMHInputTypeNSUInteger,
    /** 输入的类型为 text */
    MMHInputTypeText
};

typedef void(^MMHSingleLineInputControllerDoneBlock)(NSString *contentString);

@interface MMHSingleLineInputController : UIViewController

/** 键盘类型 */
@property (nonatomic, assign) UIKeyboardType keyboardType;
/** 默认提示语 */
@property (nonatomic, copy) NSString *placeholder;
/** 默认显示内容 */
@property (nonatomic, copy) NSString *text;
/** 输入的类型：数字、文本 */
@property (nonatomic, assign) MMHInputType inputType;

/** 点击完成按钮回调Block */
@property (nonatomic, copy) MMHSingleLineInputControllerDoneBlock doneBlock;
- (void)setDoneBlock:(MMHSingleLineInputControllerDoneBlock)doneBlock;


@end
