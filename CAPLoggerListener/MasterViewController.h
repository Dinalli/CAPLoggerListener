//
//  MasterViewController.h
//  CAPLoggerListener
//
//  Created by Andrew Donnelly on 17/08/2016.
//  Copyright © 2016 dinalli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
//@property (nonatomic, strong) MCSession *session;
//@property (nonatomic, strong) MCPeerID *peerID;
//@property (nonatomic, strong) MCNearbyServiceBrowser *serviceBrowser;


@end

