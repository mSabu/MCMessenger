//
//  MPBrowseViewController.h
//  MPMessenger
//
//  Created by Manjusha on 8/11/15.
//  Copyright © 2015 Manjusha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MPBrowseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *listLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;

- (IBAction)browseForDevices:(id)sender;
- (IBAction)disconnect:(id)sender;
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;

- (IBAction)goToMainScreen:(id)sender;

@end
