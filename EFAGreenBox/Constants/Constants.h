//
//  Constants.h
//  new_green_box
//
//  Created by Yu on 12/4/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject
extern NSString *SERVICE_URL;
extern NSString *WEBSOCKET_URL;
extern NSString *patient_id;
extern NSString *patient_name;
extern NSString *provider_npi;
extern NSString *user_id;
extern NSString *patient_user_id;
extern NSString *QRCODE_URL;

//For the patient portal
extern NSMutableArray *providers_user_ids;
@end
