//
//  DateHandler.m
//  Plonkan
//
//  Created by Olle Lind on 02/11/14.
//  Copyright (c) 2014 Olle Lind. All rights reserved.
//

#import "DateHandler.h"
#import "NSDate-Utilities.h"

@implementation DateHandler {
}

static DateHandler *_handler = nil;

- (id)init
{
	self = [super init];
	_standardFormatter = [[NSDateFormatter alloc] init];
	_standardFormatterWithoutYear = [[NSDateFormatter alloc] init];
	_monthFormatter = [[NSDateFormatter alloc]init];
	_yearFormatter = [[NSDateFormatter alloc]init];

	[_standardFormatter setDateFormat:@"EEEE, dd MMM"];
	[_standardFormatterWithoutYear setDateFormat:@"MMM-dd"];
	[_monthFormatter setDateFormat:@"MMMM"];
	[_yearFormatter setDateFormat:@"yyyy"];

	return self;
}

+ (int)year:(NSDate*)date {
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = [gregorian components:NSCalendarUnitYear fromDate:date];
    return (int)components.year;
}

+ (int)month:(NSDate*)date {
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = [gregorian components:NSCalendarUnitMonth fromDate:date];
    return (int)components.month;
}

+ (int)day:(NSDate*)date{
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = [gregorian components:NSCalendarUnitDay fromDate:date];
    return (int)components.day;
}

+ (int)hour:(NSDate*)date {
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = [gregorian components:NSCalendarUnitHour fromDate:date];
    return (int)components.hour;
}

+ (int)minute:(NSDate*)date {
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = [gregorian components:NSCalendarUnitMinute fromDate:date];
    return (int)components.minute;
}


+ (NSString *) convertTimeFormat:(NSString*)time timeFormat:(NSString *)timeFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *dateToReturn;
    NSString *truncatedString;
    time = [NSString stringWithFormat:@"%@",time];
    timeFormat = [NSString stringWithFormat:@"%@",timeFormat];
    if(time.length==8)
        truncatedString = [time substringToIndex:[time length]-3];
    else if(time.length==5)
        truncatedString = time;

    if([timeFormat isEqualToString:@"12"])
    {
        dateFormatter.dateFormat = @"HH:mm";
        dateToReturn = [dateFormatter dateFromString:truncatedString];
        dateFormatter.dateFormat = @"hh:mm a";
    }
    else if([timeFormat isEqualToString:@"24"]){
        [dateFormatter setDateFormat:@"HH:mm"];
        dateToReturn = [dateFormatter dateFromString:truncatedString];
    }
    
    return [[dateFormatter stringFromDate:dateToReturn] uppercaseString ];
}

+ (NSString *) getTimeStringFromDate:(NSDate *)date timeFormat:(NSString *)timeFormat{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if([timeFormat isEqualToString:@"12"])
    {
        NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.locale = twelveHourLocale;
        [dateFormatter setDateFormat:@"hh:mm a"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    else if([timeFormat isEqualToString:@"24"]){
        
        [dateFormatter setDateFormat:@"HH:mm"];
        NSLocale *twentyFour = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        dateFormatter.locale = twentyFour;
    }

    return [[dateFormatter stringFromDate:date] lowercaseString ];
}

#pragma mark - Date handling methods

+ (NSInteger)getMonthFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:date];
    return components.month;
}

+ (NSInteger)getYearFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:date];
    return components.year;
}


+(NSString *)getDateFromString:(NSString *)string desireDateFormat:(NSString*)desireDateFormat dateFormatWeb:(NSString*)dateFormatWeb
{
    dateFormatWeb = @"yyyy-MM-dd";
    NSDateFormatter *dateFormatter =  [DateHandler USDateFormatterWithDateFormat:dateFormatWeb];
    NSString * dateString = [NSString stringWithFormat: @"%@",string];
    NSDate* myDate = [dateFormatter dateFromString:dateString];
    
    dateFormatter = [DateHandler USDateFormatterWithDateFormat:desireDateFormat];
    dateString = [dateFormatter stringFromDate:myDate];
    
    return dateString;
}

+(NSString *)sendDateFromString:(NSString *)string formatToSend:(NSString*)formatToSend currentDateFormat:(NSString*)currentDateFormat
{
    formatToSend = @"yyyy-MM-dd";
    NSDateFormatter *dateFormatter =  [DateHandler USDateFormatterWithDateFormat:currentDateFormat];
    NSString * dateString = [NSString stringWithFormat: @"%@",string];
    NSDate* myDate = [dateFormatter dateFromString:dateString];
    
    dateFormatter = [DateHandler USDateFormatterWithDateFormat:formatToSend];
    dateString = [dateFormatter stringFromDate:myDate];
    
    return dateString;
}


+ (NSDate *)dateFromMonth:(NSInteger)month andYear:(NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    components.month = month;
    components.year = year;
    return [calendar dateFromComponents:components];
}

+ (NSDateFormatter *)USDateFormatterWithDateFormat:(NSString *)dateFormat
{
    static NSLocale* en_US_POSIX = nil;
    if (!en_US_POSIX) {
        en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    formatter.locale = en_US_POSIX;
    formatter.timeZone = [NSTimeZone systemTimeZone];
    
    if (dateFormat.length > 0) {
        formatter.dateFormat = dateFormat;
    }
    
    return formatter;
}

+ (double)GetStringTimeDiff:(NSString*)timeS timeE:(NSString*)timeE{
    double timeDiff = 0.0;
    NSDateFormatter *formatters = [[NSDateFormatter alloc] init];
    [formatters setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dateS = [formatters dateFromString:timeS];
    NSDateFormatter *formatterE = [[NSDateFormatter alloc] init];
    [formatterE setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dateE = [formatterE dateFromString:timeE];
    timeDiff = [dateE timeIntervalSinceDate:dateS ];
    return timeDiff;
}
+ (double)GetNSDateTimeDiff:(NSDate*)timeS timeE:(NSDate*)timeE{
    double timeDiff = 0.0;
    timeDiff = [timeE timeIntervalSinceDate:timeS ];
    return timeDiff;
}
+ (NSString *)NSStringDiffTime:(NSString*)startTime withEnd:(NSString *)endTime
{
    int difftime=(int)[self GetStringTimeDiff:startTime timeE:endTime];
    if ((60*60*24*2)<=difftime) {
        return startTime;
    }else if ((60*60*24*2)>=difftime&&difftime>=(60*60*24)) {
        return startTime;
    } else if((60*60)<=difftime && difftime <=(60*60*24))
    {
        int hour=(difftime)/3600;
        int min=(difftime -hour*60*60)/60;
        if (min==0) {
            return [NSString stringWithFormat:@"%d hour ago",hour];
        }else{
            return [NSString stringWithFormat:@"%d hour %d min ago",hour,min];
        }
        
    }else if(60<=difftime&&difftime<(60*60))
    {
        int min=difftime/60;
        return [NSString stringWithFormat:@"%d min ago",min];
        
    }else if(0<=difftime&&difftime<(60))
    {
        return [NSString stringWithFormat:@"new"];
    }
    return @"error";
}
+ (NSString *)NSDateDiffTime:(NSDate*)startTime withEnd:(NSDate *)endTime
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *startTimeString=[dateformatter stringFromDate:startTime];
    NSString *endTimeString=[dateformatter stringFromDate:endTime];
    return [self NSStringDiffTime:startTimeString withEnd:endTimeString];
}

+(int)isEndDateIsSmallerThanCurrent:(NSDate *)starDate checkEndDate:(NSDate*)checkEndDate
{
  
    NSDate *firstTime   = starDate;
    NSDate *secondTime  = checkEndDate;
    
    NSComparisonResult result = [firstTime compare:secondTime];
    if(result == NSOrderedDescending)
    {
        return 1;
    }
    else if(result == NSOrderedAscending)
    {
        return 2;
    }
    else
    {
        return 0;
    }
    
    
    return result;
}


//+ (int)isEndDateIsSmallerThanCurrent:(NSDate *)starDate checkEndDate:(NSDate*)checkEndDate
//{
//    NSDate* enddate = checkEndDate;
//    NSDate* currentdate = starDate;
//    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
//    double secondsInMinute = 60;
//    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
//    
//    if (secondsBetweenDates == 0)
//        return 2;
//    else if (secondsBetweenDates < 0)
//        return 1;
//    else
//        return 0;
//    
////    
////    NSComparisonResult result = [firstTime compare:secondTime];
////    if(result == NSOrderedDescending)
////    {
////        return 1;
////    }
////    else if(result == NSOrderedAscending)
////    {
////        return 2;
////    }
////    else
////    {
////        return 0;
////    }
//}


+(int)compareTwoTimeInterval:(NSString*)startTime endTime:(NSString*)endTime timeFormat:(NSString*)timeFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSLocale *locale;
    if([timeFormat isEqualToString:@"12"]){
        [dateFormatter setDateFormat:@"hh:mm a"];
        locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:locale];
    }
    else if([timeFormat isEqualToString:@"24"]){
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        dateFormatter.locale = locale;
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    
    
    NSDate *firstTime   = [dateFormatter dateFromString:startTime];
    NSDate *secondTime  = [dateFormatter dateFromString:endTime];
    
    NSComparisonResult result = [firstTime compare:secondTime];
    if(result == NSOrderedDescending)
    {
        return 1;
    }
    else if(result == NSOrderedAscending)
    {
        return 2;
    }
    else
    {
        return 0;
    }
    
    
    return result;
}


+(NSString *) getDateStringFromDate:(NSDate *)date desireDateFormat:(NSString*)desireDateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:desireDateFormat];
    return [dateFormatter stringFromDate:date];
}

//+(NSString *)getDateFromString:(NSString *)string desireDateFormat:(NSString*)desireDateFormat
//{
//    
//    NSString * dateString = [NSString stringWithFormat: @"%@",string];
//    
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    NSDate* myDate = [dateFormatter dateFromString:dateString];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
//    [formatter setDateFormat:desireDateFormat];
//    NSString *stringFromDate = [formatter stringFromDate:myDate];
//    
//    NSLog(@"%@", stringFromDate);
//    return stringFromDate;
//}

+ (DateHandler *)handler
{
	static dispatch_once_t onceToken;
	//thread-safe way to create a singleton
	dispatch_once(&onceToken, ^{
	    _handler = [[DateHandler allocWithZone:nil] init];
	});
	return _handler;
}


//***********************Show Time And Hide Time********************************************************

// provide a string of the provided date based on the relation to the current date
// if date is today, return Today and time
// if date is within last week, return day of week and if flag is not 0 time
// if date is more than a week earlier return date and if flad is not 0 time
-(NSString *) formatDisplayDateString: (NSDate *) dateToFormat flag: (int) flag {
    
#ifdef flow
    NSLog (@"method %@ formatDisplayDataString entered", self);
#endif
    
    // set date/time format to be displayed
    // compare memo date to today
    NSDate *now = [NSDate date];
    
    // set the date format to display
    static NSDateFormatter *dateOnlyFormat = nil;
    if (dateOnlyFormat == nil) {
        dateOnlyFormat = [[NSDateFormatter alloc] init];
        [dateOnlyFormat setDateStyle:NSDateFormatterMediumStyle];
    }
    
    // set the time format to display
    static NSDateFormatter *timeOnlyFormat = nil;
    if (timeOnlyFormat == nil) {
        timeOnlyFormat = [[NSDateFormatter alloc] init];
        [timeOnlyFormat setTimeStyle:NSDateFormatterShortStyle];
    }
    
    // set day of week format to display
    static NSDateFormatter *dayOfWeekOnly = nil;
    if (dayOfWeekOnly == nil) {
        dayOfWeekOnly = [[NSDateFormatter alloc] init];
        [dayOfWeekOnly setDateFormat:@"EEEE"]; // day, like "Saturday"
    }
    
    // get the number of days between today and the date
    NSInteger daysBetween = [self daysWithinEraFromDate:dateToFormat toDate:now];
    
    //NSLog(@"daysBetween is %i", daysBetween);
    //NSLog(@"  ");
    
    // compare memo date to today to determine which format to use in memo display
    NSString *dateLabel;
    if (daysBetween == 0) {
        // set date format to display Today and time only as Today 10:15 AM
        dateLabel = @"Today ";
        dateLabel = [dateLabel stringByAppendingString:[timeOnlyFormat stringFromDate:dateToFormat]];
        
    }
    // date within last week show day of week
    else if (0 < daysBetween && daysBetween < 7) {
        // display the day of week
        dateLabel = [dayOfWeekOnly stringFromDate:dateToFormat];
        
        // if flag not 0 then add time to date
        if (flag) {
            dateLabel = [dateLabel stringByAppendingString:@" "];
            dateLabel = [dateLabel stringByAppendingString:[timeOnlyFormat stringFromDate:dateToFormat] ];
        }
        
        // all other dates show the date
    } else {
        // set date format to display date only as Apr 13, 2013
        dateLabel = [dateOnlyFormat stringFromDate:dateToFormat];
        
        // if flag not 0 then add time to date
        if (flag) {
            dateLabel = [dateLabel stringByAppendingString:@" "];
            dateLabel = [dateLabel stringByAppendingString:[timeOnlyFormat stringFromDate:dateToFormat] ];
        }
    }
    
    return dateLabel;
}


// from Apple example on determining days between two days as the number of midnights between
-(NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate {
    
    // set the current calendar
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSInteger startDay = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit: NSEraCalendarUnit forDate: startDate];
    NSInteger endDay = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate: endDate];
    /*
     NSLog(@"startDate is %@", startDate);
     NSLog(@"endDate is %@", endDate);
     NSLog(@"start Day is %i", startDay);
     NSLog(@"end Day is %i", endDay);
     */
    return endDay-startDay;
    
}


- (NSString *)standardStringFromDate:(NSDate *)date
{
	if ([date isToday])
		return NSLocalizedString(@"Today", nil);
	else if ([date isYesterday])
		return NSLocalizedString(@"Yesterday", nil);
	else
		return [_standardFormatter stringFromDate:date];
}

- (NSString *)periodStringFromDate:(NSDate *)date period:(Period)period
{
	NSString *periodString;
	switch (period) {
		case PeriodWeek:
			periodString = [NSString stringWithFormat:@"%@ %ld", NSLocalizedString(@"Week", nil), [date week]];
			break;

		case PeriodMonth:
			periodString = [_monthFormatter stringFromDate:date];
			break;

		case PeriodYear:
			periodString = [_yearFormatter stringFromDate:date];
			break;

		default:
			break;
	}
	return periodString;
}

- (NSString *)firstLetterOfDay:(NSDate *)date
{
	NSString *fullString = [_standardFormatter stringFromDate:date];
	return [[fullString substringToIndex:1] uppercaseString];
}


static NSDateFormatter *formatter = nil;
static NSString *defaultFormat = @"yyyy-MM-dd HH:mm:ss";

+ (NSDate *)dateFromString:(NSString *)dateString {
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateFormat:defaultFormat];
    
    return [formatter dateFromString:dateString];
}

+ (NSString *)dateStringFromDate:(NSDate *)date {
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateFormat:defaultFormat];
    
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString forFormat:(NSString *)format {
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateFormat:format];
    
    return [formatter dateFromString:dateString];
}

+ (NSString *)dateStringFromDate:(NSDate *)date forFormat:(NSString *)format {
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

@end
