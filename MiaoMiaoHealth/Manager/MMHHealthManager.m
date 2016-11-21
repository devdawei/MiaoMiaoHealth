//
//  MMHHealthManager.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/30.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHHealthManager.h"
#import <HealthKit/HealthKit.h>

#define CustomHealthErrorDomain @"com.sdqt.healthError"

@interface MMHHealthManager ()

@property (nonatomic, strong) HKHealthStore *healthStore;

@end

@implementation MMHHealthManager

+ (instancetype)sharedManager
{
    static MMHHealthManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
    });
    return manager;
}

#pragma mark 检查是否支持获取健康数据
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion
{
#ifdef __IPHONE_8_0
    /*
     查看healthKit在设备上是否可用，ipad不支持HealthyKit
     */
    if (![HKHealthStore isHealthDataAvailable])
    {
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:@"HealthKit is not available in this Device"
                                                                 forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain: @"com.raywenderlich.tutorials.healthkit"
                                             code:2
                                         userInfo:userInfoDict];
        if(compltion) compltion(NO, error);
    }
    else
    {
        if(nil == self.healthStore) self.healthStore = [HKHealthStore new];
        /*
         组装需要读写的数据类型
         */
        NSSet *writeDataTypes = [self dataTypesWrite];
        NSSet *readDataTypes = [self dataTypesRead];
        
        /*
         注册需要读写的数据类型，也可以在“健康”APP中重新修改
         */
        [self.healthStore requestAuthorizationToShareTypes:writeDataTypes
                                                 readTypes:readDataTypes
                                                completion:^(BOOL success, NSError *error) {
                                                    
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                        DLog(@"error: %@", error.localizedDescription);
                                                        if(compltion) compltion(success, error);
                                                    }];
                                                    
                                                }];
    }
#else
    NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:@"iOS系统低于8.0"
                                                             forKey:NSLocalizedDescriptionKey];
    NSError *aError = [NSError errorWithDomain:CustomHealthErrorDomain
                                          code:0
                                      userInfo:userInfoDict];
    compltion(NO, aError);
#endif
}

#pragma mark 写权限
/**
 *  写权限
 *  @return 集合
 */
- (NSSet *)dataTypesWrite
{
#if 0
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    return [NSSet setWithObjects:heightType, temperatureType, weightType, activeEnergyType, nil];
#else
    return [NSSet set];
#endif
}

#pragma mark 读权限
/**
 *  读权限
 *  @return 集合
 */
- (NSSet *)dataTypesRead
{
#if 0
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *temperatureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    HKCharacteristicType *sexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    // 步数
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    // 步行+跑步距离
    HKQuantityType *distance = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    return [NSSet setWithObjects:heightType, temperatureType,birthdayType,sexType,weightType,stepCountType, distance, activeEnergyType,nil];
#else
    // 步数
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    // 步行+跑步距离
    HKQuantityType *distance = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    return [NSSet setWithObjects:stepCountType, distance, nil];
#endif
}


#pragma mark 获取步数
- (void)readStepCount:(void(^)(double value, NSError *error))completion
{
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    // Since we are interested in retrieving the user's latest sample, we sort the samples in descending order, and set the limit to 1. We are not filtering the data, and so the predicate is set to nil.
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepType
                                                           predicate:[MMHHealthManager predicateForSamplesToday]
                                                               limit:HKObjectQueryNoLimit
                                                     sortDescriptors:@[ timeSortDescriptor ]
                                                      resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                          
                                                          if(error)
                                                          {
                                                              if(completion) completion(NO, error);
                                                          }
                                                          else
                                                          {
                                                              NSUInteger totleSteps = 0;
                                                              for(HKQuantitySample *quantitySample in results)
                                                              {
                                                                  HKQuantity *quantity = quantitySample.quantity;
                                                                  HKUnit *heightUnit = [HKUnit countUnit];
                                                                  double usersHeight = [quantity doubleValueForUnit:heightUnit];
                                                                  totleSteps += usersHeight;
                                                              }
                                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                  DLog(@"当天行走步数: %ld",(long)totleSteps);
                                                                  if(completion) completion(totleSteps, error);
                                                              }];
                                                          }
                                                          
                                                      }];
    
    [self.healthStore executeQuery:query];
}


#pragma mark 获取公里数
- (void)readDistance:(void(^)(double value, NSError *error))completion
{
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:distanceType
                                                           predicate:[MMHHealthManager predicateForSamplesToday]
                                                               limit:HKObjectQueryNoLimit
                                                     sortDescriptors:@[timeSortDescriptor]
                                                      resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                                                          
                                                          if(error)
                                                          {
                                                              if(completion) completion(NO, error);
                                                          }
                                                          else
                                                          {
                                                              double totleSteps = 0;
                                                              for(HKQuantitySample *quantitySample in results)
                                                              {
                                                                  HKQuantity *quantity = quantitySample.quantity;
                                                                  HKUnit *distanceUnit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
                                                                  double usersHeight = [quantity doubleValueForUnit:distanceUnit];
                                                                  totleSteps += usersHeight;
                                                              }
                                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                  DLog(@"当天行走距离: %.2f",totleSteps);
                                                                  if(completion) completion(totleSteps,error);
                                                              }];
                                                          }
                                                          
                                                      }];
    [self.healthStore executeQuery:query];
}

#pragma mark 当天时间段
/**
 *  当天时间段
 *
 *  @return 时间段
 */
+ (NSPredicate *)predicateForSamplesToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

@end
