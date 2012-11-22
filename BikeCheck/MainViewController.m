//
//  MainViewController.m
//  BikeCheck
//
//  Created by Rose CW on 11/21/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//
NSString* API_KEY = @"MW9S-E7SL-26DU-VV8V";

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getStations];
}

-(void) getStations{
//:(void(^)(void))completionBlock{
    RKClient *client = [RKClient clientWithBaseURLString:@"http://api.bart.gov/"];
    
    NSDictionary *params = [NSDictionary dictionaryWithKeysAndObjects:
                            @"key", API_KEY,
                            @"cmd", @"stns",
                            nil
                            ];
    [client get:@"/api/stn.aspx" usingBlock:^(RKRequest *request) {
        request.params = params;
        request.onDidLoadResponse = ^(RKResponse *response){
            id parsedResponse = [response parsedBody:NULL];
            NSLog(@"%@", parsedResponse);
        };
        request.onDidFailLoadWithError = ^(NSError *error){
            NSLog(@"%@", error);
        };
    }];
}









-(void) checkBartWithDepart:(NSString*) depart andArrive:(NSString*) arrive {
    RKClient *client = [RKClient clientWithBaseURLString:@"http://api.bart.gov/api/stn.aspx"];

    NSDictionary *params = [NSDictionary dictionaryWithKeysAndObjects:
                            @"key", API_KEY,
                            @"cmd", @"depart",
                            @"depart", depart,
                            @"arrive", arrive,
                            nil];
    [client get:@"/" queryParameters:params delegate:self];
    
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    if (request.method == RKRequestMethodGET) {
        id xmlParser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeXML];
        id parsedResponse = [xmlParser objectFromString:[response bodyAsString] error:nil];
        NSDictionary* rss = parsedResponse;
        
        NSArray* rssChannelItemLevel = [[[rss valueForKey:@"rss"] valueForKey:@"channel"] valueForKey:@"item"];
        for (NSDictionary* itemDictionary in rssChannelItemLevel){

            
        }
        
    }
}






- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    if (request.method == RKRequestMethodGET) {
    }
}

-(void)refresh{
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    
}













- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
