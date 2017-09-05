//
//  AppDelegate.m
//  TTSCollectionViewManager
//
//  Created by Gary on 05/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "AppDelegate.h"
#import "TTSCollectionViewController.h"
#import "TTSCollectionConfig.h"
#import "DemoCollectionViewController.h"
#import "CompareCollectionCollectionViewController.h"
#import <BBNetwork.h>
#import "NetworkAssistant.h"
#import <SDImageCache.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    application.applicationSupportsShakeToEdit = NO;
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    [[SDImageCache sharedImageCache] setMaxMemoryCost:5000000];
    
    
    [[BBNetworkConfig sharedInstance] setBaseUrl:TT_Global_Api_Domain];
    NSDictionary *dic =@{
                         @"Authorization"       : DEFAULT_ACCESS_TOKEN,
                         @"VERSION"     : APP_VERSION
                         };
    [[BBNetworkConfig sharedInstance] setRequestHeaderFieldValueDictionary:dic];
    [[NetworkAssistant sharedAssistant] setHeaderDic:dic];
    
    NetWorkUrlBlock block = ^(NSString *url){
        
        url = [NSString stringWithFormat:@"%@%@",TT_Global_Api_Domain,url];
        
        return url;
    };
    
    [[NetworkAssistant sharedAssistant] setUrlBlock:block];
    
    
    [[TTSCollectionConfig sharedInstance] mapWithMappingInfo:@{
                                                               @(1) : @{
                                                                       kTTSCollectionUrlKey : INTERFACE_PRODUCTS,
                                                                       kTTSCollectionDataManagerClassKey: @"ASDemoSectionsDataManager",
                                                                       kTTSCollectionDataSourceClassKey : @"DemoDataSource"
                                                                       }
                                                               }];
    
    
    
    
    
    
    DemoCollectionViewController *ttsVC = [[DemoCollectionViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:ttsVC];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
