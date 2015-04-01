//
//  DKEntriesLoader.m
//  iHandbook
//
//  Created by denis kotenko on 20.08.10.
//  Copyright 2010 freelancer. All rights reserved.
//

#import "DKAsyncDataLoader.h"
#import "PDColoredProgressView.h"


@implementation DKAsyncDataLoader

@synthesize delegate;
@synthesize requestUrl;
@synthesize progressViewForUpdate;

// -------------------------------------------------------------------------------

- (void) dealloc {
    [requestUrl release];
    
    [super dealloc];
}

// -------------------------------------------------------------------------------

- (id) initWithRequestUrl:(NSURL *) theRequestUrl {
    if (self == [super init]) {
        self.requestUrl = theRequestUrl;
    }
    
    return self;
}

// -------------------------------------------------------------------------------

- (id) initWithRequestUrlString:(NSString *) theRequestUrl {
    if (self == [super init]) {
        requestUrl = [[NSURL alloc] initWithString:theRequestUrl];
    }
    
    return self;
}

// -------------------------------------------------------------------------------

- (void) load {
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];

    connection = [[NSURLConnection alloc] 
        initWithRequest:request delegate:self];
    
	responseData = [[NSMutableData data] retain];
	
	if (self.delegate != nil && 
		[self.delegate conformsToProtocol:@protocol(DKAsyncDataLoaderDelegate)]) {
		[self.delegate asyncDataLoader:self startLoadingWithURL:requestUrl];
    }
}

// -------------------------------------------------------------------------------

- (void) setCompleteCallback:(id) target selector:(SEL) selector {
    completeCallbackTarget   = target;
    completeCallbackSelector = selector;
}

// -------------------------------------------------------------------------------

- (BOOL) isCompleteCallbackSet {
	if (completeCallbackTarget != nil && completeCallbackSelector != nil) {
		[completeCallbackTarget respondsToSelector:completeCallbackSelector];
		return YES;
	}
	return NO;
}

// -------------------------------------------------------------------------------

- (void) setFailedCallback:(id) target selector:(SEL) selector {
    failedCallbackTarget   = target;
    failedCallbackSelector = selector;
}

// -------------------------------------------------------------------------------

- (BOOL) isFailedCallbackSet {
	if (failedCallbackTarget != nil && failedCallbackSelector != nil &&
		[failedCallbackTarget respondsToSelector:failedCallbackSelector]) {
		return YES;
	}
	return NO;
}
// -------------------------------------------------------------------------------

- (void) setDidReceiveDataCallback:(id) target selector:(SEL) selector {
	didReceiveDataCallbackTarget   = target;
	didReceiveDataCallbackSelector = selector;
}

// -------------------------------------------------------------------------------

- (BOOL) isDidReceiveDataCallbackSet {
	if (didReceiveDataCallbackTarget != nil && didReceiveDataCallbackSelector != nil &&
		[didReceiveDataCallbackTarget respondsToSelector:didReceiveDataCallbackSelector]) {
		return YES;
	}
	return NO;
}

// -------------------------------------------------------------------------------

- (void) connection    : (NSURLConnection *) theConnection 
    didReceiveResponse : (NSURLResponse *) response {

	expectedContentLength = [response expectedContentLength];
    [responseData setLength:0];
}

// -------------------------------------------------------------------------------

- (void) connection : (NSURLConnection *) theConnection 
    didReceiveData  : (NSData *) data {
	
    [responseData appendData:data];
	
	CGFloat progress;
	if (expectedContentLength != NSURLResponseUnknownLength && progressViewForUpdate != nil) {
		progress = ([responseData length] * 100 / expectedContentLength) / 100;
		[progressViewForUpdate setProgress:progress];
	} else {
		if (self.delegate != nil && 
			[self.delegate conformsToProtocol:@protocol(DKAsyncDataLoaderDelegate)]) {
			[self.delegate asyncDataLoader:self didReceiveData:[NSNumber numberWithInt:[responseData length]]];
		} else if ([self isDidReceiveDataCallbackSet]) {
			[didReceiveDataCallbackTarget performSelector:didReceiveDataCallbackSelector 
				withObject:[NSNumber numberWithInt:[responseData length]]];
		}
	}
}

// -------------------------------------------------------------------------------

- (void) connection  : (NSURLConnection *) theConnection
    didFailWithError : (NSError *) error {

    if (self.delegate != nil && 
		[self.delegate conformsToProtocol:@protocol(DKAsyncDataLoaderDelegate)]) {
		[self.delegate asyncDataLoader:self failedLoadingDataWithError:error];
    } else if ([self isFailedCallbackSet]) {
		[failedCallbackTarget performSelector:failedCallbackSelector 
			withObject:[error localizedDescription]];
	}
	
    [connection   release];
    [responseData release];
    
    //NSLog(@"Connection failed! Error - %@", [error localizedDescription]);
}

// -------------------------------------------------------------------------------

- (void) connectionDidFinishLoading : (NSURLConnection *) theConnection {    
	if (self.delegate != nil && 
		[self.delegate conformsToProtocol:@protocol(DKAsyncDataLoaderDelegate)]) {
		[self.delegate asyncDataLoader:self completeLoadingData:responseData];
    } else if ([self isCompleteCallbackSet]) {
		[completeCallbackTarget performSelector:completeCallbackSelector
			withObject:[responseData autorelease]];
	}
    
    [connection release];
    //[responseData release];
}

// -------------------------------------------------------------------------------

@end
