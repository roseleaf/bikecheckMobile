//
//  BartStore.m
//  BikeCheck
//
//  Created by Rose CW on 11/22/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "BartStore.h"
#import <RestKit/RestKit.h>
static NSDictionary* stations;
@implementation BartStore



+(void) getStations{
    RKClient *client = [RKClient clientWithBaseURLString:@"http://bikechecks.herokuapp.com/"];
    
    [client get:@"/stationlist" usingBlock:^(RKRequest *request) {
        request.onDidLoadResponse = ^(RKResponse *response){
            id parsedResponse = [response parsedBody:NULL];
            stations = parsedResponse;
            NSLog(@"in Get Stations %@", parsedResponse);
//            completionBlock();
        };
        request.onDidFailLoadWithError = ^(NSError *error){
            NSLog(@"%@", error);
        };
    }];
}


+(NSDictionary*)listStations{
    return stations;
}







@end
