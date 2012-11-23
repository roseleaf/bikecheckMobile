//
//  MainViewController.m
//  BikeCheck
//
//  Created by Rose CW on 11/21/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "MainViewController.h"
#import "BartStore.h"
#import "Time.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.stationPicker.dataSource = self;
        self.stationPicker.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if([[BartStore listStations] allKeys] == 0 ){
        self.stationNames = [self backUpStationNames];
    } else {
        self.stationNames = [[BartStore listStations] allKeys];
    }
    if ([[BartStore listStations] allValues] == 0){
        self.stationsAbbs = [self backUpStationAbbs];
    } else {
        self.stationsAbbs = [[BartStore listStations] allValues];
    }
    self.timeLabel.text = [Time timeString];
}


//UIPicker datasource and delegate methods:
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return [self.stationNames count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.stationNames objectAtIndex:row];
}

//Here's what happens when someone stops on or clicks on a station:
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    int rowNumber = [pickerView selectedRowInComponent:0];
    int shift = rowNumber - 1;
    if (rowNumber == 0){
        shift = 1;
    }
    NSString* depart = [self.stationsAbbs objectAtIndex:rowNumber];
    NSString* arrive = [self.stationsAbbs objectAtIndex:shift];
    NSString* display = [self.stationNames objectAtIndex:[pickerView selectedRowInComponent:0]];
    self.stnDisplay.text = display;
    self.timeLabel.text = [Time timeString];
    
    //Design question: if this time issue is handled on the server, it would prevent duplication, which is always good. But if it's handled client-side, it prevents pings to the server after hours. Weighing the two, this will probably eventually move to server-side.
    if ([Time getHour]==00 & [Time getMinute]>25 || [Time getHour]<04){
        self.responseDisplay.text = @"Bart's closed, check back after 4AM, Cowboy.";
    } else {
        [self checkBartWithDepart:depart andArrive:arrive];

    }
}





//This was originally set up to consume my own REST API, but on heroku for some reason it was slower and more indirect, so it now consumes the same part of the BART API as the web app does:
-(void) checkBartWithDepart:(NSString*)depart andArrive:(NSString *)arrive{
    RKClient *client = [RKClient clientWithBaseURLString:@"http://api.bart.gov/api/"];
    
    NSDictionary* params = [NSDictionary dictionaryWithKeysAndObjects:
                            @"key", @"MW9S-E7SL-26DU-VV8V",
                            @"cmd", @"depart",
                            @"orig", depart,
                            @"dest", arrive,
                            nil];
    
    [client get:@"/sched.aspx" queryParameters:params delegate:self];
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSString* parsedResponse = [response bodyAsString];
    if ([parsedResponse rangeOfString:@"bikeflag=\"1\""].location == NSNotFound) {
        self.responseDisplay.text = @"not now, cowboy. It's been outlawed.";
    } else if ([parsedResponse rangeOfString:@"bikeflag=\"0\""].location == NSNotFound) {
        self.responseDisplay.text = @"better mount up, rough rider. It's allowed!";
    } else {
        self.responseDisplay.text = @"Ah, we're having a tiny bit o trouble. Try again soon?";
    }
}



-(void)refresh{
    [self.stationPicker reloadAllComponents];
    
}




//Noticed that the server is a bit too slow sometimes. Once in a while, we will need to have a backup and CoreData modelling/mapping seemed a bit overkill. These are fallbacks for now:
-(NSArray*)backUpStationNames{
    NSArray* names = [[NSArray alloc]initWithObjects: @"Rockridge", @"Daly City", @"San Bruno", @"Balboa Park", @"Downtown Berkeley", @"Hayward", @"12th St. Oakland City Center", @"Castro Valley", @"Coliseum/Oakland Airport", @"Pittsburg/Bay Point", @"Union City", @"Lake Merritt", @"Concord", @"24th St. Mission", @"19th St. Oakland", @"Glen Park", @"San Francisco Int'l Airport", @"Richmond", @"MacArthur", @"Millbrae", @"Powell St.", @"Montgomery St.", @"Ashby", @"Civic Center/UN Plaza", @"Fruitvale", @"South San Francisco", @"San Leandro", @"Colma", @"El Cerrito Plaza", @"Pleasant Hill/Contra Costa Centre", @"North Berkeley", @"West Dublin/Pleasanton", @"Bay Fair", @"South Hayward", @"Dublin/Pleasanton", @"Walnut Creek", @"West Oakland", @"16th St. Mission", @"Fremont", @"Embarcadero", @"El Cerrito del Norte", @"North Concord/Martinez", @"Orinda", @"Lafayette", nil];
    return names;
}
-(NSArray*)backUpStationAbbs{
    NSArray* abbs = [[NSArray alloc]initWithObjects:  @"ROCK", @"DALY", @"SBRN", @"BALB", @"DBRK", @"HAYW", @"12TH", @"CAST", @"COLS", @"PITT", @"UCTY", @"LAKE", @"CONC", @"24TH", @"19TH", @"GLEN", @"SFIA", @"RICH", @"MCAR", @"MLBR", @"POWL", @"MONT", @"ASHB", @"CIVC", @"FTVL", @"SSAN", @"SANL", @"COLM", @"PLZA", @"PHIL", @"NBRK", @"WDUB", @"BAYF", @"SHAY", @"DUBL", @"WCRK", @"WOAK", @"16TH", @"FRMT", @"EMBR", @"DELN", @"NCON", @"ORIN", @"LAFY", nil];
    return abbs;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
