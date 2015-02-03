//
//  ProfileViewController.h
//  EFAGreenBox
//
//  Created by Yu on 2/3/15.
//  Copyright (c) 2015 EFA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *name_label;
@property (strong, nonatomic) IBOutlet UILabel *gender_label;
@property (strong, nonatomic) IBOutlet UILabel *phone_label;

@end
