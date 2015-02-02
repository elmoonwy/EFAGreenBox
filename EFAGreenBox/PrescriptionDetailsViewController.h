//
//  PrescriptionDetailsViewController.h
//  new_green_box
//
//  Created by Yu on 1/16/15.
//  Copyright (c) 2015 Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PrescriptionsListViewController.h"
#import "Patient.h"
@interface PrescriptionDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *back_btn;

@property (strong, nonatomic) NSString *prescription_id;
@property (strong, nonatomic) NSString *rx_url;
@property (strong, nonatomic) NSMutableArray *table_data;

- (IBAction)back_btn_action:(id)sender;
@end
