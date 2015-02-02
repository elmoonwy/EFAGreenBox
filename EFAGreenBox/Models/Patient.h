//
//  Patient.h
//  new_green_box
//
//  Created by Yu on 12/4/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Post.h"
#import "Get.h"
#import "JSONHandler.h"

@interface Patient : NSObject

+(NSString *)Login:(NSString*)email withPassword:(NSString*) password;
+(NSString *)getMyDrugs:(NSString*)patient_id;
+(NSString *)eatDrug:(NSString*)prescription_instance_id withPatientID:(NSString*)patient_id;
+(NSString *)getSingleDrugInfo:(NSString *)drug_id;
+(NSString *)doReport:(NSString*)patient_id withDrugID:(NSString*)drug_id withSideEffects:(NSString*)side_effect;
+(NSString *)getDate:(NSString*)str;
+(NSString *)finishTakingDrug:(NSString *)prescription_instance_id;
+(NSMutableArray *)getDrugHistory: (NSString*)patient_id;
+(NSString *)getUserID:(NSString *)patient_id;
+(NSString *)getAllMyProvidersUserId:(NSString *)patient_id;
+(NSString *)getAllMyPrescriptions: (NSString*)patient_id;
+(NSString *)getDrugsInPrescription: (NSString*)patient_id withPrescriptionId:(NSString*)prescription_id;
+(NSString *)pushRx: (NSString*)rx_id;
+(void)generateNewOrder:(NSString*)pharmacy_npi withRxStr:(NSString*)Rx;
@end
