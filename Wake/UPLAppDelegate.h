//
//  UPLAppDelegate.h
//  Wake
//
//  Created by Alex Ryan on 6/22/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HueSDK_iOS/HueSDK.h>

@class PHHueSDK;

@interface UPLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PHHueSDK *phHueSDK;

#pragma mark - HueSDK


@end
