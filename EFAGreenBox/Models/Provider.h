//
//  Provider.h
//  new_green_box
//
//  Created by Yu on 12/4/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "JSONHandler.h"
#import "Post.h"
#import "Get.h"
@interface Provider : NSObject
+(NSString*)Login:(NSString*)email withPassword:(NSString*)pass;
+(NSMutableArray*)loadMyPatients;
@end
