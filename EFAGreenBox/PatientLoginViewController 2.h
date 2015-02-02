//
//  PatientLoginViewController.h
//  new_green_box
//
//  Created by Yu on 12/4/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONHandler.h"
#import "DrugsListViewController.h"
#import "Patient.h"
#import "ViewController.h"

@interface PatientLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *email_textbox;
@property (strong, nonatomic) IBOutlet UITextField *password_textbox;
@property (strong, nonatomic) IBOutlet UIButton *login_button;
@property (strong, nonatomic) IBOutlet UIButton *back_button;


- (IBAction)login_click:(id)sender;

- (IBAction)back_action:(id)sender;

@end
