//
//  syncPlainNote.m
//  PlainNote
//
//  Created by Vincent Koser on 2/26/10.
//  Copyright 2010 __kosetech__. All rights reserved.
//

#import "syncPlainNote.h"
#import "JSON/JSON.h"

@implementation syncPlainNote


//This will login the user and return a token in the form of a dictionary with the keys 
// authenticated / account_id / created
// it returns an empty dictionary if there was an issue

- (NSDictionary *) loginWithUsername:(NSString*)username andPassword:(NSString*)password andUUID:(NSString*)UUID{
	
	NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&UUID=%@",
					  username, password, UUID];
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:@"http://plainnote.kosertech.com/account/login.json"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	//post it
	[request setHTTPBody:postData];
	
	//get response
	NSHTTPURLResponse* urlResponse = nil;
	NSError *error = [[NSError alloc] init];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
	//result not really needed unless desired 
	NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response Code: %ld", (long)[urlResponse statusCode]);
	if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
		NSLog(@"Response: %@", result);
		//here you get the response
		
		// Store incoming data into a string
		NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		
		// Create a dictionary from the JSON string
		NSDictionary *results = [jsonString JSONValue];
		return results;
		
	}
	return nil;
}

- (NSInteger) postNoteWithAccountID:(NSString*)accountID 
						andDeviceID:(NSString*)deviceID 
						  andPostID:(NSString*)postID 
						 andContent:(NSString*)content{
	
	
	NSString *post = [NSString stringWithFormat:@"account_id=%@&device_id=%@&post_id=%@&content=%@",
					  accountID, deviceID, postID, content];
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:@"http://plainnote.kosertech.com/notes/update.json"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	//post it
	[request setHTTPBody:postData];
	
	//get response
	NSHTTPURLResponse* urlResponse = nil;
	NSError *error = [[NSError alloc] init];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
	//result not really needed unless desired 
	//NSString *result =
    [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response Code: %ld", (long)[urlResponse statusCode]);

	return [urlResponse statusCode];
	
	
}

// returns a string to be used as the UUID 
// should only need to call this once per device then store it for use
// from that point forward

- (NSString *)GetUUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return [(NSString *)string autorelease];
}


@end
