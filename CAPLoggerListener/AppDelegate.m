//
//  AppDelegate.m
//  CAPLoggerListener
//
//  Created by Andrew Donnelly on 17/08/2016.
//  Copyright © 2016 dinalli. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    _peerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
    
    _serviceBrowser =  [[MCNearbyServiceBrowser alloc] initWithPeer:_peerID serviceType:@"CAPLogger"];
    _serviceBrowser.delegate = self;
    [_serviceBrowser startBrowsingForPeers];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] peerID] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - MCSession Delegate
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
    switch (state)
    {
        case MCSessionStateNotConnected:
            NSLog(@"peer %@ Not connected", peerID);
            break;
        case MCSessionStateConnected:
            NSLog(@"peer %@ Connected", peerID);
            break;
        case MCSessionStateConnecting:
            NSLog(@"peer %@ Connecting", peerID);
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SESSION_STATE_CHANGED object:nil];
}

-(void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL))certificateHandler
{
    certificateHandler(true);
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"PEER ID [%@]  Data [%@]", peerID.displayName, strData);
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_RECEIVE_DATA object:nil userInfo:@{@"peerID":peerID, @"data": strData}];
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

#pragma mark MCSessionBrowser

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"Lost Peer : %@", peerID);
}

-(void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"Did not start browsing %@", error.localizedDescription);
}

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info
{
    [browser invitePeer:peerID toSession:_session withContext:nil timeout:10];
    NSLog(@"Invite Peer %@", peerID);
}

@end
