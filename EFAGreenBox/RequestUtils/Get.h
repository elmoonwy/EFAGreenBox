//
//  Get.h
//  new_green_box
//
//  Created by Yu on 12/4/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@interface Get : NSObject
+(NSString*)getRequest:(NSString*)url withParams:(NSString*)params;
@end
