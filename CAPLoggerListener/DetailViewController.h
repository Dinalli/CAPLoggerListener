//
//  DetailViewController.h
//  CAPLoggerListener
//
//  Created by Andrew Donnelly on 17/08/2016.
//  Copyright © 2016 dinalli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) MCPeerID *peerID;
@property (weak, nonatomic) IBOutlet UITextView *logsView;

@end

