//
//  RCRouterViewController.m
//  RCRouter
//
//  Created by Ross Cairns on 31/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RCRouterViewController.h"
#import "RCRouter.h"

@implementation RCRouterViewController

#pragma mark - Route Calling & Removing at Dealloc

- (void)createRoutes {
    
    [RCRouter map:@"/hello/:name/" to:self with:@selector(hello:)];
    
}

- (void)callRoutes {
    
    [RCRouter dispatch:@"/hello/Ross/"];
    
}

- (void)dealloc
{
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
