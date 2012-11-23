//
//  AppDelegate.m
//  BikeCheck
//
//  Created by Rose CW on 11/21/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "MainViewController.h"
#import "BartStore.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //Would like to refine this request a bit more before implementing here, fallbacks will be used temporarily:
//        [BartStore getStations];
        
        //This can be toned down if it is too harsh, but it gives the picker a moment to populate before launch:
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            MainViewController* mainView = [MainViewController new];
            self.window.rootViewController = mainView;
        });
        
    });

    return YES;
}

@end
