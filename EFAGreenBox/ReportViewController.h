//
//  ReportViewController.h
//  new_green_box
//
//  Created by Yu on 12/12/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"
#import "Post.h"
#import "Get.h"
#import "JSONHandler.h"
#import "DrugsListViewController.h"
#import <SocketRocket/SRWebSocket.h>

@interface ReportViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, SRWebSocketDelegate>
@property (nonatomic, strong) NSMutableArray *table_data;
@property (strong, nonatomic) IBOutlet UITableView *table_view;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSMutableArray *_pickerData;
@property (nonatomic, strong) NSMutableArray *side_effects;
@property (strong, nonatomic) IBOutlet UIButton *report_button;
@property (strong, nonatomic) NSString *selected_drug_id;

@property (strong, nonatomic) IBOutlet UIButton *back_button;

@property (strong, nonatomic) SRWebSocket *webSocket;

- (IBAction)report_action:(id)sender;
- (IBAction)back_action:(id)sender;
@end
