//
//  PrescriptionsListViewController.h
//  new_green_box
//
//  Created by Yu on 1/16/15.
//  Copyright (c) 2015 Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"
#import "DrugsListViewController.h"
#import "qrencode.h"
#import "PrescriptionDetailsViewController.h"

@interface PrescriptionsListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *table_data;
@property (strong, nonatomic) IBOutlet UIButton *back_btn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *push_button;
@property (strong, nonatomic) NSString *selected_rx_id;

- (IBAction)back_btn_action:(id)sender;
- (UIImage *)quickResponseImageForString:(NSString *)dataString withDimension:(int)imageWidth;
- (IBAction)push_button_action:(id)sender;

@end
