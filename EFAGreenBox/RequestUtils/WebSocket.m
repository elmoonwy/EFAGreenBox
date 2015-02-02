//
//  WebSocket.m
//  new_green_box
//
//  Created by Yu on 12/19/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import "WebSocket.h"

@implementation WebSocket
- (void)connectWebSocket {
    self.websocket.delegate = nil;
    self.websocket = nil;
    
    NSString *urlString = [[WEBSOCKET_URL stringByAppendingString:@"?user_id="] stringByAppendingString:user_id];
    NSLog(@"websocket url: %@", urlString);
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;
    
    [newWebSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    self.websocket = newWebSocket;
    [self.websocket send:[NSString stringWithFormat:@"Hello from %@", [UIDevice currentDevice].name]];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    //self.messagesTextView.text = [NSString stringWithFormat:@"%@\n%@", self.messagesTextView.text, message];
    NSLog(@"websocket message: %@", message);
}

- (void)sendMessage:(id)sender {
  //  [self.websocket send:self.messageTextField.text];
   // self.messageTextField.text = nil;
}
@end
