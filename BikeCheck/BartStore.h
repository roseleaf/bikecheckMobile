//
//  BartStore.h
//  BikeCheck
//
//  Created by Rose CW on 11/22/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//
#import <RestKit/RestKit.h>
#import <Foundation/Foundation.h>

@interface BartStore : NSObject <RKRequestDelegate, RKRequestQueueDelegate>
+(void) getStations;
+(NSDictionary*) listStations;

@end
