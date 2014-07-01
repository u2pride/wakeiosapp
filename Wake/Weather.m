//
//  Weather.m
//  Wake
//
//  Created by Alex Ryan on 6/30/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import "Weather.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation Weather
{
    NSDictionary *weatherServiceResponse;
}

- (id)init
{
    self = [super init];
    weatherServiceResponse = @{};
    return self;
}

- (void)getCurrent:(NSString *)query
{
    NSString *const BASE_URL_STRING = @"http://api.openweathermap.org/data/2.5/weather";
    
    NSString *weatherURLText = [NSString stringWithFormat:@"%@?q=%@",
                                BASE_URL_STRING, query];
    NSURL *weatherURL = [NSURL URLWithString:weatherURLText];
    //NSURLRequest *weatherRequest = [NSURLRequest requestWithURL:weatherURL];
    
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:weatherURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
    

}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSArray *temperature = [[json objectForKey:@"main"] objectForKey:@"temp"];
    
    NSLog(@"Current Temp: %@", temperature);
}

//- (void)parseWeatherServiceResponse
//{
//    // clouds
//    _cloudCover = [weatherServiceResponse[@"clouds"][@"all"] integerValue];
//    
//    // coord
//    _latitude = [weatherServiceResponse[@"coord"][@"lat"] doubleValue];
//    _longitude = [weatherServiceResponse[@"coord"][@"lon"] doubleValue];
//    
//    // dt
//    _reportTime = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"dt"] doubleValue]];
//    
//    // main
//    _humidity = [weatherServiceResponse[@"main"][@"humidity"] integerValue];
//    _pressure = [weatherServiceResponse[@"main"][@"pressure"] integerValue];
//    _tempCurrent = [Weather kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp"] doubleValue]];
//    _tempMin = [Weather kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp_min"] doubleValue]];
//    _tempMax = [Weather kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp_max"] doubleValue]];
//    
//    // name
//    _city = weatherServiceResponse[@"name"];
//    
//    // rain
//    _rain3hours = [weatherServiceResponse[@"rain"][@"3h"] integerValue];
//    
//    // snow
//    _snow3hours = [weatherServiceResponse[@"snow"][@"3h"] integerValue];
//    
//    // sys
//    _country = weatherServiceResponse[@"sys"][@"country"];
//    _sunrise = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"sys"][@"sunrise"] doubleValue]];
//    _sunset = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"sys"][@"sunset"] doubleValue]];
//    
//    // weather
//    _conditions = weatherServiceResponse[@"weather"];
//    
//    // wind
//    _windDirection = [weatherServiceResponse[@"wind"][@"dir"] integerValue];
//    _windSpeed = [weatherServiceResponse[@"wind"][@"speed"] doubleValue];
//}

+ (double)kelvinToCelsius:(double)degreesKelvin
{
    const double ZERO_CELSIUS_IN_KELVIN = 273.15;
    return degreesKelvin - ZERO_CELSIUS_IN_KELVIN;
}

@end
