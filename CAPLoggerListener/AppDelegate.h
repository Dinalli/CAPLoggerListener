//
//  AppDelegate.h
//  CAPLoggerListener
//
//  Created by Andrew Donnelly on 17/08/2016.
//  Copyright © 2016 dinalli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#define SESSION_STATE_CHANGED @"sessionStateChanged"
#define DID_RECEIVE_DATA @"didReceiveData"

@interface AppDelegate : UIResponder <UIApplicationDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCNearbyServiceBrowser *serviceBrowser;

@end

