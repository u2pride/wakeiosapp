//
//  UPLAppDelegate.m
//  Wake
//
//  Created by Alex Ryan on 6/22/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import "UPLAppDelegate.h"
#import "UPLHomeViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UPLAppDelegate ()

@property (nonatomic, strong) PHBridgeSearching *bridgeSearch;

@end

@implementation UPLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //self.window.rootViewController = [[UPLHomeViewController alloc] init];
    self.window.rootViewController = [UPLHomeViewController sharedInstance];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    //Hue Lights - Create SDK Instance
    self.phHueSDK = [[PHHueSDK alloc] init];
    [self.phHueSDK startUpSDK];
    [self.phHueSDK enableLogging:YES];
    
    [self searchForBridgeLocal];
    
    PHNotificationManager *notificationManager = [PHNotificationManager defaultManager];

    
    [notificationManager registerObject:self withSelector:@selector(authenticationSuccess) forNotification:PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(authenticationFailed) forNotification:PUSHLINK_LOCAL_AUTHENTICATION_FAILED_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(noLocalConnection) forNotification:PUSHLINK_NO_LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(noLocalBridge) forNotification:PUSHLINK_NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(buttonNotPressed:) forNotification:PUSHLINK_BUTTON_NOT_PRESSED_NOTIFICATION];
    
    [self.phHueSDK startPushlinkAuthentication];
    
    
    
    [notificationManager registerObject:self withSelector:@selector(localConnection) forNotification:LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(noLocalConnection) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(notAuthenticated) forNotification:NO_LOCAL_AUTHENTICATION_NOTIFICATION];
    
    
    [self.phHueSDK enableLocalConnection];

    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //Stop the Heartbeat for the Hue Lights

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //Start back the heartbeat
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)noLocalConnection {
    [self checkConnectionState];
}

- (void)localConnection {
    [self checkConnectionState];
}

- (void)notAuthenticated {
    //[self performSelector:@selector(doAuthentication) withObject:nil afterDelay:0.5];
}

- (void)noLocalBridge {
    
}

- (void)checkConnectionState {

}

#pragma mark - Heartbeat control

- (void)searchForBridgeLocal {
    // Stop heartbeats
    
    /***************************************************
     A bridge search is started using UPnP to find local bridges
     *****************************************************/
    
    // Start search
    self.bridgeSearch = [[PHBridgeSearching alloc] initWithUpnpSearch:YES andPortalSearch:YES andIpAdressSearch:YES];
    [self.bridgeSearch startSearchWithCompletionHandler:^(NSDictionary *bridgesFound) {
        // Done with search, remove loading view
        
        /***************************************************
         The search is complete, check whether we found a bridge
         *****************************************************/
        
        // Check for results
        if (bridgesFound.count > 0) {
            
            NSLog(@"Found a bridge");
            
            NSString *mac = [bridgesFound.allKeys objectAtIndex:0];
            NSString *ip = [bridgesFound objectForKey:mac];
            
            [self.phHueSDK setBridgeToUseWithIpAddress:ip macAddress:mac];
            
            /***************************************************
             Use the list of bridges, present them to the user, so one can be selected.
             *****************************************************/
            
        }
        else {
            /***************************************************
             No bridge was found was found. Tell the user and offer to retry..
             *****************************************************/
            
            
        }
    }];
}


/**
 Notification receiver which is called when the pushlinking was successful
 */
- (void)authenticationSuccess {
    // You can now enable a heartbeat to connect to this bridge
}

/**
 Notification receiver which is called when the pushlinking failed because the time limit was reached
 */
- (void)authenticationFailed {
    // Authentication failed because time limit was reached, inform the user about this and let him try again
}


/**
This method is called when the pushlinking is still ongoing but no button was pressed yet.
     @param notification The notification which contains the pushlinking percentage which has passed.
*/
- (void)buttonNotPressed:(NSNotification *)notification {
    NSLog(@"Press the Button");
    
}






@end
