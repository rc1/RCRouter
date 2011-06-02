# RCRouter

*Alpha Release*  
*(in response this [stackoverflow question](http://stackoverflow.com/questions/6189936/is-there-a-sinatra-style-routing-library-class-for-objective-c))*

Sinatra Style Routing in Objective-C. A String based routing system not tied to (UIKit or other) Navigation Controller.  
Currently only compatible with iOS4+.  
Please fork and improve and send any comment/improvements.  

### Roadmap

   + Create Unit Tests
   + Create Demo App
   + Make Regex Capabilities iOS independent (Use for Cocoa)
   + Review Memory Management

## Example Usage

	#include "RCRouter.h"

	-(id)init {
	
		// map routes
		[RCRouter map:@"/page/:title/" to:self with:@selector(page:)];
		[RCRouter map:@"/color/:r/:g/:b/:a/" to:self with:@selector(color:)];
	
		// dispatch routes
		[RCRouter dispatch:@"/page/welcome/"];
		[RCRouter dispatch:@"/color/255/255/255/255/"];
	
	}

	- (void)page:(NSDictionary*)params {
	
		NSString *pageTitle = [params objectForKey:@"title"];
	
	}

	- (void)color:(NSDictionary*)params {
	
		float red = [[params objectForKey:@"r"] floatValue];
		float green = [[params objectForKey:@"g"] floatValue];
		float blue = [[params objectForKey:@"b"] floatValue];
	
	}

## Delegate

A delegate to the Router can be added by using the following:

    [RCRouter addDelegate:self];

The following optional delegate methods are available as part of <RCRouterDelegate>:
	
	- (BOOL)allow:(NSString*)route;
	- (void)willDispatchRoute:(NSString*)route to:(id)object;
	- (void)didDispatchRoute:(NSString*)route to:(id)object;
	- (void)noRouteFor:(NSString*)route;
	