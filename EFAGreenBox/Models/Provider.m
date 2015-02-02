//
//  Provider.m
//  new_green_box
//
//  Created by Yu on 12/4/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import "Provider.h"

@implementation Provider
+(NSString*)Login:(NSString *)email withPassword:(NSString *)pass{
    NSString *params=[NSString stringWithFormat:@"email=%@&password=%@", email, pass];
    return [Post postRequest:[SERVICE_URL stringByAppendingString:@"users/login.json"] withParams:params];
}

+(NSMutableArray*)loadMyPatients{
    NSString *params=[NSString stringWithFormat:@"?provider_npi=%@", provider_npi];
    NSString *result=[Get getRequest:[SERVICE_URL stringByAppendingString:@"users/load_my_patients.json"] withParams: params];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[JSONHandler StringToData:result] options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *res_list=[dic objectForKey:@"result"];
    return res_list;
}
@end
