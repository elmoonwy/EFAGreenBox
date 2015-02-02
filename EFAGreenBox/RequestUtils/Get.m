//
//  Get.m
//  new_green_box
//
//  Created by Yu on 12/4/14.
//  Copyright (c) 2014 Yu. All rights reserved.
//

#import "Get.h"

@implementation Get
+(NSString*)getRequest:(NSString *)url withParams:(NSString *)params{
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] init];
    url=[url stringByAppendingString: params];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}
@end
