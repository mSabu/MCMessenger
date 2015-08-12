//
//  MPMainViewController.m
//  MPMessenger
//
//  Created by Manjusha on 8/11/15.
//  Copyright © 2015 Manjusha. All rights reserved.
//

#import "MPMainViewController.h"
#import "MPButton.h"

@interface MPMainViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UITextView *messagesDisplay;
@property (weak, nonatomic) IBOutlet MPButton *connectDeviceOutlet;

@end

@implementation MPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _messageText.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:kDataReceivedNotification
                                               object:nil];
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification
{
    if ([[MPManager sharedManager]isConnected]) {
        _connectDeviceOutlet.enabled = NO;
    }
    
    MCPeerID *peerID = [[notification userInfo] objectForKey:kPeerId];
    NSString *peerDisplayName = peerID.displayName;
    NSData *receivedData = [[notification userInfo] objectForKey:kData];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    [_messagesDisplay performSelectorOnMainThread:@selector(setText:) withObject:[_messagesDisplay.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMessage];
    return YES;
}

-(void)sendMessage{
    NSData *dataToSend = [_messageText.text dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = [[MPManager sharedManager]session].connectedPeers;
    NSError *error;    
    [[[MPManager sharedManager]session] sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }
    
    [_messagesDisplay setText:[_messagesDisplay.text stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n", _messageText.text]]];
    [_messageText setText:@""];
    [_messageText resignFirstResponder];
}

@end
