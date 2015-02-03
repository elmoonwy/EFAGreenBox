//
//  SettingsViewController.h
//  EFAGreenBox
//
//  Created by Yu on 2/3/15.
//  Copyright (c) 2015 EFA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *full_name_textbox;
@property (strong, nonatomic) IBOutlet UITextField *old_password_textbox;
@property (strong, nonatomic) IBOutlet UITextField *newpassword_textbox;
@property (strong, nonatomic) IBOutlet UITextField *password_confirm_textbox;
@property (strong, nonatomic) IBOutlet UIButton *update_btn;
- (IBAction)update_action:(id)sender;

@end
