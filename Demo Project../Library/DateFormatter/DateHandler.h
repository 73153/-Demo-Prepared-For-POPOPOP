//
//  DateHandler.h
//  Plonkan
//
//  Created by Olle Lind on 02/11/14.
//  Copyright (c) 2014 Olle Lind. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@interface DateHandler : NSObject


typedef enum{
    PeriodWeek = 0,
    PeriodMonth = 1,
    PeriodYear = 2,
}Period;

@property (nonatomic, strong) NSDateFormatter *standardFormatter;
@property (nonatomic, strong) NSDateFormatter *standardFormatterWithoutYear;
@property (nonatomic, strong) NSDateFormatter *monthFormatter;
@property (nonatomic, strong) NSDateFormatter *yearFormatter;

+ (NSString *) getTimeStringFromDate:(NSDate *)date timeFormat:(NSString *)timeFormat;
+ (NSInteger)getMonthFromDate:(NSDate *)date;
+ (NSInteger)getYearFromDate:(NSDate *)date;
+ (NSDate *)dateFromMonth:(NSInteger)month andYear:(NSInteger)year;

+ (int)hour:(NSDate*)date;
+ (int)minute:(NSDate*)date;
+ (int)isEndDateIsSmallerThanCurrent:(NSDate *)starDate checkEndDate:(NSDate*)checkEndDate;

+ (NSDateFormatter *)USDateFormatterWithDateFormat:(NSString *)dateFormat;
+(NSString *)getDateFromString:(NSString *)string desireDateFormat:(NSString*)desireDateFormat dateFormatWeb:(NSString*)dateFormatWeb;
+(NSString *)sendDateFromString:(NSString *)string formatToSend:(NSString*)formatToSend currentDateFormat:(NSString*)currentDateFormat;
/**
 * 只返回时间差,不计算时间
 * returns only time, the computing time
 */
+ (double)GetStringTimeDiff:(NSString*)timeS timeE:(NSString*)timeE;
/**
 * 只返回时间差,不计算时间
 * returns only time, the computing time
 */
+ (double)GetNSDateTimeDiff:(NSDate*)timeS timeE:(NSDate*)timeE;
/**
 * 返回时间
 * The return time
 */
+ (NSString *)NSStringDiffTime:(NSString*)startTime withEnd:(NSString *)endTime;
/**
 * 返回时间
 * The return time
 */
+ (NSString *)NSDateDiffTime:(NSDate*)startTime withEnd:(NSDate *)endTime;

+ (int)year:(NSDate*)date;
+ (int)month:(NSDate*)date;
+ (int)day:(NSDate*)date;

+ (DateHandler *)handler;
- (NSString *)standardStringFromDate:(NSDate *)date;
- (NSString *)periodStringFromDate:(NSDate *)date period:(Period)period;
- (NSString *)firstLetterOfDay:(NSDate *)date;

+(int)compareTwoTimeInterval:(NSString*)startTime endTime:(NSString*)endTime timeFormat:(NSString*)timeFormat;

+ (NSString *) convertTimeFormat:(NSString*)time timeFormat:(NSString *)timeFormat;
//***********************Show Time And Hide Time********************************************************
// provide a string of the provided date based on the relation to the current date
// if date is today, return Today and time
// if date is within last week, return day of week and if flag is not 0 time
// if date is more than a week earlier return date and if flad is not 0 time
-(NSString *) formatDisplayDateString: (NSDate *) dateToFormat flag: (int) flag;

// from Apple example on determining days between two days as the number of midnights between
-(NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate;

+(NSString *) getDateStringFromDate:(NSDate *)date desireDateFormat:(NSString*)desireDateFormat;
//+(NSString *)getDateFromString:(NSString *)string desireDateFormat:(NSString*)desireDateFormat;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)dateStringFromDate:(NSDate *)date;

+ (NSDate *)dateFromString:(NSString *)dateString forFormat:(NSString *)format;
+ (NSString *)dateStringFromDate:(NSDate *)date forFormat:(NSString *)format;

@end
