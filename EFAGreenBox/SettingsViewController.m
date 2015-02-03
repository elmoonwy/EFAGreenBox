//
//  SettingsViewController.m
//  EFAGreenBox
//
//  Created by Yu on 2/3/15.
//  Copyright (c) 2015 EFA. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)update_action:(id)sender {
    NSString *new_password=self.newpassword_textbox.text;
    NSString *old_password=self.old_password_textbox.text;
    NSString *email=self.email_textbox.text;
    NSString *password_confirm=self.password_confirm_textbox.text;
    NSLog(@"lalala: %@ , %@", new_password, password_confirm);
    if(![new_password isEqualToString: password_confirm]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwords are not the same!"
                                                        message:@"2 passwords are not equal!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString *res=[Patient Login:email withPassword:old_password];
    NSDictionary *user_dic=[NSJSONSerialization JSONObjectWithData:[JSONHandler StringToData:res] options:NSJSONReadingMutableContainers error:nil];
    if([[user_dic objectForKey:@"status"] intValue]==200){
        NSString *res=[Patient updatePassword:new_password withEmail:email throughUserID: user_id];
        if([res isEqualToString:@"yes"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Success"
                                                            message:@"Password updated success!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            self.newpassword_textbox.text=@"";
            self.old_password_textbox.text=@"";
            self.email_textbox.text=@"";
            self.password_confirm_textbox.text=@"";
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The old password is not correct!"
                                                        message:@"The old password is not correct, please make sure you inpit the correct previous password!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
}
@end
