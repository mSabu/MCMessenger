//
//  MPBrowseViewController.m
//  MPMessenger
//
//  Created by Manjusha on 8/11/15.
//  Copyright © 2015 Manjusha. All rights reserved.
//

#import "MPBrowseViewController.h"

@interface MPBrowseViewController () <MCBrowserViewControllerDelegate, UITextFieldDelegate> {
    NSMutableArray *arrConnectedDevices;
}
@end

@implementation MPBrowseViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    arrConnectedDevices = [[NSMutableArray alloc] init];
    
    self.deviceName.text = [UIDevice currentDevice].name;
    
    [[MPManager sharedManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[MPManager sharedManager] advertiseSelf:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:kStateChangeNotification
                                               object:nil];
    
}

- (IBAction)browseForDevices:(id)sender {
    [[MPManager sharedManager] setupMCBrowser];
    [[[MPManager sharedManager]mcBrowser] setDelegate:self];
    
    [self presentViewController:[[MPManager sharedManager]mcBrowser] animated:YES completion:nil];
}

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    __weak __typeof(self)weakSelf = self;
    [[[MPManager sharedManager]mcBrowser] dismissViewControllerAnimated:YES completion:^{[weakSelf goToMainScreen:nil];}];
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [[[MPManager sharedManager]mcBrowser] dismissViewControllerAnimated:YES completion:nil];
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSDictionary *dict = @{kPeerId: peerID,
                           kState : [NSNumber numberWithInt:state]
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:kStateChangeNotification
                                                        object:nil
                                                      userInfo:dict];
}

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:kPeerId];
    NSString *peerDisplayName = peerID.displayName;
    
    self.listLabel.text = peerDisplayName;
    
    MCSessionState state = [[[notification userInfo] objectForKey:kState] intValue];
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [arrConnectedDevices addObject:peerDisplayName];
            _listLabel.text = peerDisplayName;
            [[MPManager sharedManager] setIsConnected: YES];
        }
        else if (state == MCSessionStateNotConnected){
            if ([arrConnectedDevices count] > 0) {
                int indexOfPeer = (int)[arrConnectedDevices indexOfObject:peerDisplayName];
                [arrConnectedDevices removeObjectAtIndex:indexOfPeer];
                BOOL peersExist = ([[[[MPManager sharedManager]session] connectedPeers] count] == 0);
                [_btnDisconnect setEnabled:!peersExist];
                [[MPManager sharedManager] setIsConnected: NO];
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Button action methods
- (IBAction)disconnect:(id)sender {
    
    [[[MPManager sharedManager]session] disconnect];
    [arrConnectedDevices removeAllObjects];
    [self goToMainScreen:nil];
}
- (IBAction)goToMainScreen:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
