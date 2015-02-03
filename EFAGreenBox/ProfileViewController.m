//
//  ProfileViewController.m
//  EFAGreenBox
//
//  Created by Yu on 2/3/15.
//  Copyright (c) 2015 EFA. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *arr=[Patient getMyProfile:user_id];
    NSLog(@"arr: %@", [arr objectAtIndex:2]);
    self.name_label.text=[[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:0]];
    self.gender_label.text=[[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:1]];
    self.phone_label.text=[[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:2]];
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

@end
