//
//  DetailViewController.m
//  CAPLoggerListener
//
//  Created by Andrew Donnelly on 17/08/2016.
//  Copyright © 2016 dinalli. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLogData:) name:DID_RECEIVE_DATA object:nil];
}

-(void)reloadLogData:(NSNotification *)notification
{
    MCPeerID *notificationPeerID = (MCPeerID *)[notification.userInfo objectForKey:@"peerID"];
    NSString *data = [notification.userInfo objectForKey:@"data"];
    
    if(notificationPeerID == _peerID)
    {
        dispatch_async(dispatch_get_main_queue(), ^(){
            _logsView.text = [NSString stringWithFormat:@"data: %@ \n\n %@", data, _logsView.text];
        });
    }
//    logTextView.text = [NSString stringWithFormat:@"type: %@ \n %@", [eventInfo objectForKey:@"eventType"], logTextView.text];
//    logTextView.text = [NSString stringWithFormat:@"time: %@ \n %@", [eventInfo objectForKey:@"eventTimestamp"], logTextView.text];
//    logTextView.text = [NSString stringWithFormat:@"vin:  %@ \n %@", [eventInfo objectForKey:@"vin"], logTextView.text];
//    logTextView.text = [NSString stringWithFormat:@"id:   %@ \n %@", [eventInfo objectForKey:@"eventId"], logTextView.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
