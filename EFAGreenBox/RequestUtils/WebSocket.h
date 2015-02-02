//
//  WebSocket.h
//  new_green_box
//
//  Created by Yu on 12/19/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>
#import "Constants.h"
#import <UIKit/UIKit.h>
@interface WebSocket : NSObject <SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *websocket;

- (void)connectWebSocket;
- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket;
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message ;
@end
