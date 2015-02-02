//
//  PatientLoginViewController.h
//  EFAGreenBox
//
//  Created by Yu on 2/2/15.
//  Copyright (c) 2015 EFA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEMORootViewController.h"
#import "JSONHandler.h"
#import "DrugsListViewController.h"
#import "Patient.h"
#import "NUIAppearance.h"

@interface PatientLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *email_textbox;
@property (strong, nonatomic) IBOutlet UITextField *password_textbox;

@property (strong, nonatomic) IBOutlet UIButton *login_btn;
@property (strong, nonatomic) IBOutlet UIButton *reset_button;

- (IBAction)login_action:(id)sender;
@end
