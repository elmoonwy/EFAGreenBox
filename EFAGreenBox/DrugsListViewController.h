//
//  DrugsListViewController.h
//  new_green_box
//
//  Created by Yu on 12/8/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"
#import "JSONHandler.h"
#import "ReportViewController.h"
#import "PatientLoginViewController.h"
#import <SocketRocket/SRWebSocket.h>
#import "ZBarSDK.h"
#import "PrescriptionsListViewController.h"
@interface DrugsListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SRWebSocketDelegate, ZBarReaderDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table_view;
@property (strong, nonatomic) NSMutableArray *table_data;
@property (strong, nonatomic) IBOutlet UIButton *report_button;
@property (strong, nonatomic) SRWebSocket *webSocket;
@property (strong, nonatomic) IBOutlet UIButton *back_button;

//talking picture components

@property (strong, nonatomic) IBOutlet UIButton *scan_qrcode_btn;
@property (strong, nonatomic) IBOutlet UILabel *result_text;
@property (strong, nonatomic) IBOutlet UIImageView *resultImageView;

//prescription button
@property (strong, nonatomic) IBOutlet UIButton *rx_btn;


- (IBAction)report_action:(id)sender;
- (IBAction)back_action:(id)sender;
- (IBAction)scan_qrcode_action:(id)sender;
- (IBAction)rx_btn_action:(id)sender;


@end
