//
//  RCRouterViewController.m
//  RCRouter
//
//  Created by Ross Cairns on 31/05/2011.
//  RossCairns.com | TheWorkers.net
//

#import "RCRouterViewController.h"

@implementation RCRouterViewController

#pragma mark - Route Calling & Removing at Dealloc

- (void)createRoutes {
    
    [RCRouter map:@"/hello/" to:self with:@selector(hello:)];
    [RCRouter map:@"/hello/:name/" to:self with:@selector(hello:)];
    [RCRouter map:@"/hello/:name/:fishlips/" to:self with:@selector(hello:)];
    
}

- (void)callRoutes {
    
    [RCRouter dispatch:@"/your/will/never/find/this"];
    [RCRouter dispatch:@"/hello/"];
    [RCRouter dispatch:@"/hello/Ross/"];
    [RCRouter dispatch:@"/hello/from/home/"];
    
}

- (void)dealloc
{
    NSLog(@"RCRouterViewController dealloc");
    
    // example removing a single route
    [RCRouter remove:@"/hello/:name/"];
    
    // example: remove all the routes for this object
    // this must be done to avoid memory leaks
    [RCRouter removeAllRoutesToReceiver:self];
    
    [super dealloc];
}

#pragma mark - Mapped Routes


- (void)hello:(NSDictionary*)params {
    
    NSLog(@"Hello was called with the following params \n %@", params);
    
}


#pragma mark - Router delegate methods

- (BOOL)allow:(NSString*)route {
 
    // NSLog(@"allow");
    
    return YES;
    
}

- (void)willDispatchRoute:(NSString*)route to:(id)object {
    
    // NSLog(@"willDispatchRoute: %@", route);
    
}

- (void)didDispatchRoute:(NSString*)route to:(id)object {
    
    // NSLog(@"didDispatchRoute: %@", route);
    
}

- (void)noRouteFor:(NSString*)route {
    
    NSLog(@"Route not found: %@", route);
    
}



#pragma mark - Hatches, Matches and Dispatches



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [RCRouter addDelegate:self];
    
    // run the tests
    // this should be setup as unit tests
    [self createRoutes];
    [self callRoutes];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
