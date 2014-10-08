//
//  UPLStockHueViewController.m
//  Wake
//
//  Created by Alex Ryan on 10/7/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import "UPLStockHueViewController.h"
#import <HueSDK_iOS/HueSDK.h>
#import "UPLAppDelegate.h"
#define MAX_HUE 65535
#define LIGHT_GREEN 10000
#define MEDIUM_GREEN 20000
#define DARK_GREEN 30000
#define LIGHT_RED 40000
#define MEDIUM_RED 50000
#define DARK_RED 60000




@interface UPLStockHueViewController ()

@property (nonatomic, strong) NSMutableArray *arrayOfStocks;
@property (nonatomic, strong) NSMutableArray *stockRecord;


@end

@implementation UPLStockHueViewController

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
    // Do any additional setup after loading the view.
    
    self.arrayOfStocks = [[NSMutableArray alloc] initWithObjects:@"AAPL", @"NKE", @"WFM", @"TSLA", nil];
    self.stockRecord = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.arrayOfStocks count]; i++) {
        
        NSString *requestString = [NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@&f=sl1d1t1c1ohgv&e=.csv", [self.arrayOfStocks objectAtIndex:i]];
        NSLog(@"%@", requestString);
        
        NSURLRequest *stockInfoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:stockInfoRequest returningResponse:&response error:&error];
        NSString *strData = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

        if (error == nil) {
            //Parsing Data
            NSArray *percentChange = [strData componentsSeparatedByString:@","];
            //Add the Perecent Change for Each Stock in arrayOfStocks to stockRecord
            [self.stockRecord addObject:[percentChange objectAtIndex:i]];
        }
    }
    
    
    //Frames
    CGRect pickerFrame = CGRectMake(0, 200, self.view.frame.size.width/2.0 + 30, 300);
    CGRect percentChangeLabel = CGRectMake(self.view.frame.size.width/2.0, 200, 100, 100);
    
    UIPickerView *stockList = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stockList.backgroundColor = [UIColor redColor];
    stockList.delegate = self;
    stockList.dataSource = self;
    UILabel *stockChange = [[UILabel alloc] initWithFrame:percentChangeLabel];
    stockChange.backgroundColor = [UIColor blueColor];
    stockChange.text = @"7.0";
    
    //Set the initial selection of the picker
    [stockList selectRow:1 inComponent:0 animated:YES];
    
    //Show the UI
    [self.view addSubview:stockList];
    [self.view addSubview:stockChange];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.arrayOfStocks count];
}


#pragma mark - UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.arrayOfStocks objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    //Grab Phillips Cache and bridgeSendAPI
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    PHBridgeSendAPI *bridgeSendAPI = [[PHBridgeSendAPI alloc] init];
    
    PHLight *light = [cache.lights objectForKey:@"2"];
    PHLightState *state = [[PHLightState alloc] init];
    
    
    float selectedStockPercentChange = [[self.stockRecord objectAtIndex:row] floatValue];
    
    
    if (selectedStockPercentChange < -6.0) {
        state.brightness = @220;
        state.hue = [NSNumber numberWithInt:DARK_RED];
    } else if (selectedStockPercentChange < -3.0) {
        state.brightness = @220;
        state.hue = [NSNumber numberWithInt:MEDIUM_RED];
    } else if (selectedStockPercentChange < 0.0) {
        state.brightness = @220;
        state.hue = [NSNumber numberWithInt:LIGHT_RED];
    } else if (selectedStockPercentChange == 0) {
        state.brightness = @220;
        state.hue = [NSNumber numberWithInt:MAX_HUE];
    } else if (selectedStockPercentChange < 3.0) {
        state.brightness = @220;
        state.hue = [NSNumber numberWithInt:LIGHT_GREEN];
    } else if (selectedStockPercentChange < 6.0) {
        state.brightness = @220;
        state.hue = [NSNumber numberWithInt:MEDIUM_GREEN];
    } else {
        state.brightness = @220;
        state.hue = [NSNumber numberWithInt:DARK_GREEN];
    }
    
    
    
    [bridgeSendAPI updateLightStateForId:light.identifier withLightState:state completionHandler:^(NSArray *errors) {
        if (!errors) {
            NSLog(@"Update Sucessful");
        } else {
            NSLog(@"Update Failed");
        }
    }];
    

    /*
     
     PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
     PHBridgeSendAPI *bridgeSendAPI = [[PHBridgeSendAPI alloc] init];
     
     for (PHLight *light in cache.lights.allValues) {
     
     PHLightState *lightState = [[PHLightState alloc] init];
     
     [lightState setHue:[NSNumber numberWithInt:arc4random() % MAX_HUE]];
     [lightState setBrightness:[NSNumber numberWithInt:254]];
     [lightState setSaturation:[NSNumber numberWithInt:254]];
     
     // Send lightstate to light
     [bridgeSendAPI updateLightStateForId:light.identifier withLightState:lightState completionHandler:^(NSArray *errors) {
     if (errors != nil) {
     NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
     
     NSLog(@"Response: %@",message);
     }
     
     }];
     }
     */

    
    
    /*
    //Messing with the Hue Lights
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    //NSArray *myLights = [cache.lights allValues];
    
    PHLight *light = [cache.lights objectForKey:@"2"];
    PHLightState *state = light.lightState;
    float randomNumber = (float) arc4random_uniform(65535);
    NSNumber *randomHue = [NSNumber numberWithFloat:randomNumber];
    state.hue = randomHue;
    
    PHBridgeSendAPI *bridgeSendAPI = [[PHBridgeSendAPI alloc] init];
    
    [bridgeSendAPI updateLightStateForId:light.identifier withLightState:state completionHandler:^(NSArray *errors) {
        if (!errors) {
            NSLog(@"Update Sucessful");
        } else {
            NSLog(@"Update Failed");
        }
    }];
    */
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
