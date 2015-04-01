//
//  DKRequest.m
//  iHandbook
//
//  Created by denis kotenko on 19.08.10.
//  Copyright 2010 freelancer. All rights reserved.
//

#import "DKSyncDataLoader.h"


@implementation DKSyncDataLoader

// -------------------------------------------------------------------

- (void) dealloc {   
    [super dealloc];
}

// -------------------------------------------------------------------

- (NSData *) load:(NSString *) url {    
    NSURL        *requestUrl = [NSURL URLWithString:url];
    NSURLRequest *request    = [NSURLRequest requestWithURL:requestUrl];
    
    NSURLResponse *response  = nil;
    NSError       *error     = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request 
        returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"Request failed: %@", [error description]);
        return nil;
    }
    
//    NSString *responseString = [[NSString alloc] 
//        initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"responseString: %@", responseString);
	
    return responseData;
}

// -------------------------------------------------------------------

@end
