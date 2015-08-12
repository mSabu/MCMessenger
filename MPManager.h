//
//  MPManager.h
//  MPMessenger
//
//  Created by Manjusha on 8/11/15.
//  Copyright © 2015 Manjusha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MPManager : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic) BOOL isConnected;
@property (nonatomic, strong) MCBrowserViewController *mcBrowser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;
-(void)resetManager;

+ (id)sharedManager;
@end
