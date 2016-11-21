//
//  NSString+Helper.h
//  DingDangB2B
//
//  Created by 大威 on 16/7/12.
//  Copyright © 2016年 药交汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Helper)

/**
 转化为MD5字符串

 @return MD5字符串
 */
- (NSString *)md5String;

/**
 *  判断是否为正确的邮箱
 *
 *  @return 返回YES为正确的邮箱，NO为不是邮箱
 */
- (BOOL)isValidateEmail;

/**
 *  判断是否为正确的手机号
 *
 *  @return 返回YES为手机号，NO为不是手机号
 */
- (BOOL)checkTel;

/**
 *  清空字符串中的空白字符
 *
 *  @return 清空空白字符串之后的字符串
 */
- (NSString *)trimString;

/**
 *  是否空字符串
 *
 *  @return 如果字符串为nil或者长度为0返回YES
 */
- (BOOL)isEmptyString;

/**
 *  返回沙盒中的文件路径
 *
 *  @return 返回当前字符串对应在沙盒中的完整文件路径
 */
+ (NSString *)stringWithDocumentsPath:(NSString *)path;

/**
 *  写入系统偏好
 *
 *  @param key 写入键值
 */
- (void)saveToUserDefaultsWithKey:(NSString *)key;

/**
 一串字符在固定宽度下，正常显示所需要的高度

 @param string 文本内容
 @param width  每一行的宽度
 @param font   字体大小

 @return 高度
 */
+ (CGFloat)dynamicHeightWithString:(NSString *)string
                             width:(CGFloat)width
                              font:(UIFont *)font;

/**
 一串字符在一行中正常显示所需要的宽度

 @param string 文本内容
 @param font   字体大小

 @return 宽度
 */
+ (CGFloat)dynamicWidthWithString:(NSString *)string
                             font:(UIFont *)font;

/**
 将UTC时间转化为标准时间

 @param utcDate      UTC时间
 @param formatString 格式化

 @return 格式化的标准时间
 */
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate
                                  format:(NSString *)formatString;

/**
 获得设备型号

 @return 获得设备型号
 */
+(NSString *)getCurrentDeviceModel;

@end
