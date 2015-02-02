//
//  JSONHandler.h
//  new_green_box
//
//  Created by Yu on 12/6/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONHandler : NSObject
+(NSString*)DataToString:(NSData*)data;
+(NSData*)StringToData: (NSString*)str;
+(NSString *)ObjectToJSON: (id)obj;
@end
