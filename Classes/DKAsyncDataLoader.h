//
//  DKEntriesLoader.h
//  iHandbook
//
//  Created by denis kotenko on 20.08.10.
//  Copyright 2010 freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PDColoredProgressView;

@interface DKAsyncDataLoader : NSObject {

	id delegate;
	
	id  completeCallbackTarget;
    SEL completeCallbackSelector;
    
    id  failedCallbackTarget;
    SEL failedCallbackSelector;
	
	id  didReceiveDataCallbackTarget;
	SEL didReceiveDataCallbackSelector;
	
    NSURL           *requestUrl;
    NSMutableData   *responseData;
    NSURLConnection *connection;
	
	long expectedContentLength;
    PDColoredProgressView *progressViewForUpdate;
	
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSURL *requestUrl;
@property (nonatomic, assign) PDColoredProgressView *progressViewForUpdate;


- (id) initWithRequestUrl:(NSURL *) theRequestUrl;
- (id) initWithRequestUrlString:(NSString *) theRequestUrl;

- (void) load;
- (void) setCompleteCallback:(id) target selector:(SEL) selector;
- (void) setFailedCallback:(id) target selector:(SEL) selector;
- (void) setDidReceiveDataCallback:(id) target selector:(SEL) selector;

@end


@protocol DKAsyncDataLoaderDelegate <NSObject>

@optional
- (void) asyncDataLoader:(DKAsyncDataLoader *) dataLoader
	didReceiveData:(NSNumber *) dataLength;

@required
- (void) asyncDataLoader:(DKAsyncDataLoader *) dataLoader
	 startLoadingWithURL:(NSURL *) url;

- (void) asyncDataLoader:(DKAsyncDataLoader *) dataLoader
	 completeLoadingData:(NSData *) data;

- (void) asyncDataLoader:(DKAsyncDataLoader *) dataLoader
	failedLoadingDataWithError:(NSError *) error;

@end