//
//  Patient.m
//  new_green_box
//
//  Created by Yu on 12/4/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import "Patient.h"

@implementation Patient
+(NSString*)Login:(NSString *)email withPassword:(NSString *)password{
    NSString *str=[[NSString alloc] initWithFormat:@"email=%@&password=%@", email, password];
    return [Post postRequest:[SERVICE_URL stringByAppendingString:@"users/login.json"] withParams:str];
}

+(NSString*)getMyDrugs:(NSString *)patient_id{
    NSString *res=[[NSString alloc] initWithFormat:@"patient_id=%@", patient_id];
    return [Get getRequest:[SERVICE_URL stringByAppendingString:@"users/get_my_drugs?"] withParams: res];
}

+(NSString *)eatDrug:(NSString *)prescription_instance_id withPatientID:(NSString*)patient_id{
    NSString *param=[[NSString alloc] initWithFormat:@"prescription_instance_id=%@&patient_id=%@", prescription_instance_id, patient_id];
    return [Post postRequest:[SERVICE_URL stringByAppendingString:@"medications/eat_drug.json"] withParams:param];
}

+(NSString *)getSingleDrugInfo:(NSString *)drug_id{
    NSString *params=[[NSString alloc] initWithFormat:@"drug_id=%@", drug_id];
    return [Get getRequest:[SERVICE_URL stringByAppendingString:@"medications/get_single_drug?"] withParams:params];
}

+(NSString *)doReport:(NSString *)patient_id withDrugID:(NSString *)drug_id withSideEffects:(NSString *)side_effect{
    NSString *params=[[NSString alloc] initWithFormat:@"patient_id=%@&drug_id=%@&side_effects=%@", patient_id, drug_id, side_effect];
    return [Post postRequest:[SERVICE_URL stringByAppendingString:@"reports/add_report"] withParams:params];
}

+ (NSDate *) getDate:(NSString *)str{
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate=[formater stringFromDate:[NSDate date]];
    stringFromDate=[[stringFromDate stringByAppendingString:@" "] stringByAppendingString:str];
    NSDate *date=[formater dateFromString:stringFromDate];
    return date;
}

+(NSString*)finishTakingDrug:(NSString *)prescription_instance_id{
    NSString *param=[[NSString alloc] initWithFormat:@"prescription_instance_id=%@", prescription_instance_id];
    return [Post postRequest:[SERVICE_URL stringByAppendingString:@"medications/finish_taking_drug.json"]withParams: param];
}

+(NSMutableArray *)getDrugHistory:(NSString *)patient_id{
    NSString *param=[[NSString alloc] initWithFormat:@"patient_id=%@", patient_id];
    NSString *res_str= [Get getRequest:[SERVICE_URL stringByAppendingString:@"medications/get_drug_history?"] withParams:param];
    NSDictionary *res_dic=[NSJSONSerialization JSONObjectWithData:[JSONHandler StringToData:res_str] options:NSJSONReadingMutableContainers error:nil];
    return [res_dic objectForKey:@"result"];
}

+(NSString *)getUserID:(NSString *)patient_id{
    NSString *param=[[NSString alloc] initWithFormat:@"patient_id=%@", patient_id];
    return [Get getRequest:[SERVICE_URL stringByAppendingString:@"users/get_patient_user_id?"] withParams:param];
}

//getAllMyProvidersId, get all of providers that as long as they assigned me drugs
+(NSString *)getAllMyProvidersUserId: (NSString *)patient_id{
    NSString *param=[[NSString alloc] initWithFormat:@"patient_id=%@", patient_id];
    return [Get getRequest:[SERVICE_URL stringByAppendingString:@"providers/get_all_my_providers_user_id.json?"] withParams:param];
}

//get this patient's all unpaid prescriptions
+(NSString *)getAllMyPrescriptions: (NSString *)patient_id{
    NSString *param=[[NSString alloc] initWithFormat:@"patient_id=%@", patient_id];
    return [Get getRequest:[SERVICE_URL stringByAppendingString:@"prescriptions/show_rxs?"] withParams:param];
}
//get all drug that belongs to a single prescription
+(NSString*)getDrugsInPrescription:(NSString *)patient_id withPrescriptionId:(NSString *)prescription_id{
    NSString *param=[[NSString alloc] initWithFormat:@"patient_id=%@&prescription_id=%@", patient_id, prescription_id];
    return [Get getRequest:[SERVICE_URL stringByAppendingString:@"prescriptions/rx_details?"] withParams:param];
}

+(NSString*)pushRx:(NSString *)rx_id{
    NSString *param=[[NSString alloc] initWithFormat:@"prescription_id=%@", rx_id];
    return [Post postRequest:[SERVICE_URL stringByAppendingString:@"prescriptions/push_rx"] withParams:param];
}

+(void)generateNewOrder:(NSString *)pharmacy_npi withRxStr:(NSString*)Rx{
    NSString *param_rx=[[NSString alloc] initWithFormat:@"prescription_id=%@", Rx];
    NSString *res=[Post postRequest:[SERVICE_URL stringByAppendingString:@"pharmacists/create_order"] withParams:param_rx];
    NSLog(@"the result must be: %@", res);
}

+(NSArray*)getMyProfile:(NSString*)user_id{
    NSString *param=[[NSString alloc] initWithFormat:@"user_id=%@", user_id];
    NSString *res=[Get getRequest:[SERVICE_URL stringByAppendingString:@"users/get_my_profile.json?"] withParams: param];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[JSONHandler StringToData:res] options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr=[[NSArray alloc] initWithArray:[dic allValues]];
    return arr;
}

+(NSString*)updatePassword:(NSString*)new_password withEmail:(NSString*)email throughUserID:(NSString*)user_id{
    NSString *param=[[NSString alloc] initWithFormat:@"new_password=%@&email=%@&user_id=%@", new_password, email, user_id];
    return [Post postRequest:[SERVICE_URL stringByAppendingString:@"users/update_password"] withParams:param];
}
@end
