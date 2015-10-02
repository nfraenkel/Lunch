//
//  GetChoicesCommand.m
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import "GetChoicesCommand.h"

@implementation GetChoicesCommand

-(void)fetchChoices {
    NSLog(@"[GetChoicesCommand] fetching relevant choices.....");
    
    // spinnaz
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // TODO - api url
    NSString *url = [NSString stringWithFormat:@"%@/api/venues", SERVER];
    
    // HTTP request, setting stuff
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    // start connection
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark connection protocol functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"[GetChoicesCommand] conection did receive response!");
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"[GetChoicesCommand] conection did receive data!");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Please do something sensible here, like log the error.
    NSLog(@"[GetColletionsCommand] connection failed with error: %@", error.description);
    
    // stop spinners
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate reactToGetChoicesError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"[GetChoicesCommand] connectiondidfinishloading!");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    NSMutableArray *choices = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in dictResponse){
        Choice *cc = [[Choice alloc] initWithDictionary:dict];
        
        // add collection to list of collections
        [choices addObject:cc];
    }
    
    [self.delegate reactToGetChoicesResponse:choices];
    
}

@end
