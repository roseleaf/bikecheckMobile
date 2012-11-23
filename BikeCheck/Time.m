//
//  Time.m
//  BikeCheck
//
//  Created by Rose CW on 11/23/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "Time.h"

@implementation Time
+(int)getHour{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    dateString = [formatter stringFromDate:[NSDate date]];
    int hour = [dateString intValue];
    return hour;
}
+(int)getMinute{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    dateString = [formatter stringFromDate:[NSDate date]];
    int minute = [dateString intValue];
    return minute;
}

+(NSString*)timeString{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}
@end
