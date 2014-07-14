//
//  Weather.m
//  Wake
//
//  Created by Alex Ryan on 6/30/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import "Weather.h"
#import "UPLHomeViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation Weather
{
    NSDictionary *weatherServiceResponse;
}
@synthesize tempCurrent;

- (id)init
{
    self = [super init];
    weatherServiceResponse = @{};
    NSLog(@"INIT BEFORE SET %@", tempCurrent);
    tempCurrent = [NSNumber numberWithInt:0];
    NSLog(@"INIT AFTER SET %@", tempCurrent);

    return self;
}

- (void)getCurrentWithLat:(double)latitude withLong:(double)longitude
{
    NSString *const BASE_URL_STRING = @"http://api.openweathermap.org/data/2.5/weather";
    
    NSString *weatherURLText = [NSString stringWithFormat:@"%@?lat=%f&lon=%f",
                                BASE_URL_STRING, latitude, longitude];
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
    weatherServiceResponse = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    [self parseWeatherServiceResponse];

}

- (void)parseWeatherServiceResponse
{
    
    //NSArray *temperature = [[json objectForKey:@"main"] objectForKey:@"temp"];


    
    _cloudCover = [[[weatherServiceResponse objectForKey:@"clouds"] objectForKey:@"all"] integerValue];
    
    _latitude = [[[weatherServiceResponse objectForKey:@"coord"] objectForKey:@"lat"] doubleValue];
    _longitude = [[[weatherServiceResponse objectForKey:@"coord"] objectForKey:@"lon"] doubleValue];
    
    double reportTime = [[weatherServiceResponse objectForKey:@"dt"] doubleValue];
    _reportTime = [NSDate dateWithTimeIntervalSince1970:reportTime];
    
    _humidity = [[[weatherServiceResponse objectForKey:@"main"] objectForKey:@"humidity"] integerValue];
    _pressure = [[[weatherServiceResponse objectForKey:@"main"] objectForKey:@"pressure"] integerValue];
    tempCurrent = [NSNumber numberWithDouble:[Weather kelvinToF:[[[weatherServiceResponse objectForKey:@"main"] objectForKey:@"temp"] doubleValue]]];
    _tempMin = [Weather kelvinToF:[[[weatherServiceResponse objectForKey:@"main"] objectForKey:@"temp_min"] doubleValue]];
    _tempMax = [Weather kelvinToF:[[[weatherServiceResponse objectForKey:@"main"] objectForKey:@"temp_max"] doubleValue]];

    _city = [weatherServiceResponse objectForKey:@"name"];
    
    _rain3hours = [[[weatherServiceResponse objectForKey:@"rain"] objectForKey:@"3h"] integerValue];
    _snow3hours = [[[weatherServiceResponse objectForKey:@"snow"] objectForKey:@"3h"] integerValue];

    _country = [[weatherServiceResponse objectForKey:@"sys"] objectForKey:@"country"];
    
    double sunrise = [[[weatherServiceResponse objectForKey:@"sys"] objectForKey:@"sunrise"] doubleValue];
    double sunset = [[[weatherServiceResponse objectForKey:@"sys"] objectForKey:@"sunset"] doubleValue];
    _sunrise = [NSDate dateWithTimeIntervalSince1970:sunrise];
    _sunset = [NSDate dateWithTimeIntervalSince1970:sunset];
    
    _conditions = [weatherServiceResponse objectForKey:@"weather"];
    
    _windDirection = [[[weatherServiceResponse objectForKey:@"wind"] objectForKey:@"dir"] integerValue];
    _windSpeed = [[[weatherServiceResponse objectForKey:@"wind"] objectForKey:@"speed"] doubleValue];
  
    
    [[UPLHomeViewController sharedInstance] updatedWeather:[tempCurrent intValue]];
    //UPLHomeViewController *vc = (UPLHomeViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    //[vc updatedWeather:[tempCurrent intValue]];
    
    NSLog(@"Parse END %@", tempCurrent);
}

+ (double)kelvinToF:(double)degreesKelvin
{
    const double ZERO_CELSIUS_IN_KELVIN = 273.15;
    return (degreesKelvin - ZERO_CELSIUS_IN_KELVIN) * 1.80;
}


@end