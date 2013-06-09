//
//  clsAppDelegate.m
//  FotoKartoon
//
//  Created by Vishalsinh Jhala on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "clsAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation clsAppDelegate

@synthesize window = _window;
@synthesize tracker = _tracker;

void MarkCrashed(int flag);


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    // Override point for customization after application launch.
    
    //[TestFlight takeOff:@"4ad6b8cdebf246bf28d017f30eea5dd8_MTMwMTA1MjAxMi0wOS0wOSAwNzoxNTo0Ni43OTM0ODQ"];

    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 60;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-37566182-1"];

    return YES;
}


- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation 
{
    return [FBSession.activeSession handleOpenURL:url]; 
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/////////////////
//Crash Report
///////////////////
/*void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);      
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]); 
    //MarkCrashed(1);
    
}
void MarkCrashed(int flag)
{
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] 
                                      initWithContentsOfFile:@"MessMyLooks-Info"];
    
    if(flag)
        [plistDict setValue:@"1" forKey:@"Crashed"];
    else
        [plistDict setValue:@"0" forKey:@"Crashed"];
        
    [plistDict writeToFile:@"MessMyLooks-Info" atomically: YES];
}*/




@end
