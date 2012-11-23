//
//  MainViewController.h
//  BikeCheck
//
//  Created by Rose CW on 11/21/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "BartStore.h"

@interface MainViewController : UIViewController <RKRequestDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
//View Elements:
@property (weak, nonatomic) IBOutlet UILabel *responseDisplay;
@property (weak, nonatomic) IBOutlet UILabel *stnDisplay;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *stationPicker;
//Variables:
@property (strong) NSArray* stationNames;
@property (strong) NSArray* stationsAbbs;
@end
