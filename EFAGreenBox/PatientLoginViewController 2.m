//
//  PatientLoginViewController.m
//  new_green_box
//
//  Created by Yu on 12/4/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import "PatientLoginViewController.h"


@interface PatientLoginViewController ()

@end

@implementation PatientLoginViewController

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

- (IBAction)login_click:(id)sender {
    NSString *res=[Patient Login:self.email_textbox.text withPassword:self.password_textbox.text];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[JSONHandler StringToData:res] options:NSJSONReadingMutableContainers error:nil];
    if([[dic objectForKey:@"status"] intValue]==200){
        NSDictionary *user_dic=[dic objectForKey:@"result"];
        patient_id=[user_dic objectForKey:@"patient_id"];
        patient_name=[[NSString alloc] initWithFormat:@"%@ %@", [user_dic objectForKey:@"fname"], [user_dic objectForKey:@"lname"]];
        NSLog(@"patient name: %@", patient_name);
        NSLog(@"the user id is: %@", [user_dic objectForKey:@"user_id"]);
        user_id=[user_dic objectForKey:@"user_id"];
        //Get all my providers id
        NSString *res2=[Patient getAllMyProvidersUserId:patient_id];
        NSDictionary *dic2=[NSJSONSerialization JSONObjectWithData:[JSONHandler StringToData:res2] options:NSJSONReadingMutableContainers error:nil];
        providers_user_ids=[[NSMutableArray alloc] init];
        providers_user_ids=[dic2 objectForKey:@"result"];
        NSLog(@"the class is : %@", [providers_user_ids class]);
        DrugsListViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"DrugsListViewController"];
        [self presentViewController:view animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email or password is wrong!"
                                                        message:@"You must input the correct email and password!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)back_action:(id)sender {
    ViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:view animated:YES completion:nil];
}

@end
