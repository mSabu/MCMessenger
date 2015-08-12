//
//  MPManager.m
//  MPMessenger
//
//  Created by Manjusha on 8/11/15.
//  Copyright © 2015 Manjusha. All rights reserved.
//

#import "MPManager.h"

@implementation MPManager

static MPManager *sharedManager = nil;

+ (id)sharedManager {
    static dispatch_once_t oncePred;
    dispatch_once(&oncePred, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


-(id)init{
    self = [super init];
    
    if (self) {
        _peerID = nil;
        _session = nil;
        _mcBrowser = nil;
        _advertiser = nil;
    }
    
    return self;
}
-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName{
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}
-(void)setupMCBrowser{
    _mcBrowser = [[MCBrowserViewController alloc] initWithServiceType:kMPFiles session:_session];
}
-(void)advertiseSelf:(BOOL)shouldAdvertise{
    if (shouldAdvertise) {
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:kMPFiles
                                                           discoveryInfo:nil
                                                                 session:_session];
        [_advertiser start];
    }
    else{
        [_advertiser stop];
        _advertiser = nil;
    }
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSLog(@"didReceiveData from peer: %@, %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding], peerID);
    
    NSDictionary *dict = @{kData: data,
                           kPeerId: peerID
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDataReceivedNotification
                                                        object:nil
                                                      userInfo:dict];
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

- (void)resetManager {
    _peerID = nil;
    _session = nil;
    _mcBrowser = nil;
    _advertiser = nil;
}

@end
