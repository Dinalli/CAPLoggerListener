//
//  MasterViewController.m
//  CAPLoggerListener
//
//  Created by Andrew Donnelly on 17/08/2016.
//  Copyright © 2016 dinalli. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@interface MasterViewController ()
{
    AppDelegate *appDelegate;
}

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:SESSION_STATE_CHANGED object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData {
    
    dispatch_async(dispatch_get_main_queue(), ^(){ [self.tableView reloadData]; });
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        MCPeerID *connectedPeerID = appDelegate.session.connectedPeers[[self.tableView indexPathForSelectedRow].row];
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setPeerID:connectedPeerID];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.title = connectedPeerID.displayName;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return appDelegate.session.connectedPeers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    MCPeerID *connectedPeerID = appDelegate.session.connectedPeers[indexPath.row];
    cell.textLabel.text = connectedPeerID.displayName;
    return cell;
}

@end
