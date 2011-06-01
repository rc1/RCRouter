////
//  RCRoute.m
//  RCRouter
//
//  Created by Ross Cairns on 01/06/2011.
//  RossCairns.com | TheWorkers.net
//

#import "RCRoute.h"

@interface RCRoute () 

@property (nonatomic, retain) NSRegularExpression *checkForMatchRegEx;
@property (nonatomic, retain) NSRegularExpression *extractParamValuesRegEx;
@property (nonatomic, retain) NSArray *parameterNames;

@end

@implementation RCRoute

@synthesize checkForMatchRegEx=_checkForMatchRegEx;
@synthesize extractParamValuesRegEx=_extractParamValuesRegEx;
@synthesize parameterNames=_parameterNames;
@synthesize receiver=_receiver;
@synthesize selector=_selector;
@synthesize route=_route;

- (void)dealloc {
    
    [_route release];
    [_receiver release];
    [_parameterNames release];
    [_checkForMatchRegEx release];
    [_extractParamValuesRegEx release];
    
    [super dealloc];
}

- (id)initWithRoute:(NSString*)route to:(id)receiver with:(SEL)selector {
    
    if ((self = [super init])) {
        
        self.receiver = receiver;
        self.selector = selector;
        _route = [route retain];
        
    
        // Create a regex for matching paths 
        //
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(:[A-Za-z0-9-_]*)" 
                                                                               options:NSRegularExpressionAnchorsMatchLines 
                                                                                 error:&error];
        
        NSString *result = [regex stringByReplacingMatchesInString:route 
                                                           options:0 
                                                             range:NSMakeRange(0, [route length]) 
                                                      withTemplate:@"([A-Za-z0-9-_.]*)"];
        
        // add a $ to the end of the regex and carat to start
        // ^/home/(:[A-Za-z0-9-_])*/
        NSString *pattern = [NSString stringWithFormat:@"^%@$", result];
        
        // create the regex
        self.checkForMatchRegEx = [NSRegularExpression regularExpressionWithPattern:pattern 
                                                                            options:NSRegularExpressionAnchorsMatchLines 
                                                                              error:&error]; 
        
        // create the regex for finding the params
        NSArray *ranges = [regex matchesInString:route options:0 range:NSMakeRange(0, [route length])];
        NSString *patternForExtractingValues = @"";
        NSTextCheckingResult *rangeresult;
        
        if ([ranges count] > 0) {
            
            for (NSInteger i=0; i<[ranges count]; i++) {
                    
                rangeresult = [ranges objectAtIndex:i]; 
                
                if (i==0) {
                    
                    NSRange startRange;
                    startRange.location = 0;
                    startRange.length = rangeresult.range.location;
                    
                    patternForExtractingValues = [NSString stringWithFormat:@"(?<=%@)", [route substringWithRange:startRange]]; 

                    
                }
                
                patternForExtractingValues = [NSString stringWithFormat:@"%@([A-Za-z0-9-_.]*)(?:/)", patternForExtractingValues]; 
                
            }
            
        }
        
        self.extractParamValuesRegEx = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"%@",   patternForExtractingValues]
                                                                               options:NSRegularExpressionAnchorsMatchLines 
                                                                                 error:&error];

        
        // Get the parameter names
        NSRegularExpression *paramNamesRegex = [NSRegularExpression regularExpressionWithPattern:@"((?!/)(?<=:).*?(?=/))" 
                                                                                         options:0 
                                                                                           error:&error];
        
        NSArray *parameterNamesRaw =[paramNamesRegex matchesInString:route options:0 range:NSMakeRange(0, [route length])];
        
        if ([parameterNamesRaw count] > 0) {
            
            NSMutableArray *parameterNames = [[NSMutableArray alloc] initWithCapacity:[parameterNamesRaw count]];
            NSEnumerator *namesEnumerator = [parameterNamesRaw objectEnumerator];
            NSTextCheckingResult *find;
            
            while ((find = [namesEnumerator nextObject])) {
                
                NSString *name = [route substringWithRange:find.range];
                [parameterNames addObject:name];
                
            }
            
            self.parameterNames = [NSArray arrayWithArray:parameterNames];
            
            [parameterNames release];
            
            
        } else {
            
            self.parameterNames = nil;
            
        }
        
    }
    
    return self;
}

- (BOOL)matches:(NSString*)path {
    
    NSUInteger numberOfMatches = [self.checkForMatchRegEx numberOfMatchesInString:path 
                                                                          options:0 
                                                                            range:NSMakeRange(0, [path length])];
    
    if (numberOfMatches > 0) {
        return YES;
    } else {
        return NO;
    }
    
}

- (NSDictionary*)paramsForPath:(NSString*)path { 
    
    // there is no parameters
    if ([_parameterNames count] == 0) return nil;
    
    
    NSArray *matches = [self.extractParamValuesRegEx matchesInString:path
                                                             options:0
                                                               range:NSMakeRange(0, [path length])];
    
    NSMutableArray *paramsValues = [[NSMutableArray alloc] initWithCapacity:[_parameterNames count]];
    
    for (NSTextCheckingResult *match in matches) {

        // ignoring  first capture group
        for (NSInteger i=1; i<=self.extractParamValuesRegEx.numberOfCaptureGroups; i++ ) {
            
            //NSLog(@"Capture group %d: %@", i, [path substringWithRange:[match rangeAtIndex:i]]);
            [paramsValues addObject:[path substringWithRange:[match rangeAtIndex:i]]];
            
        }
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects:paramsValues forKeys:_parameterNames];
    
    [paramsValues release];
    
    return params;

}

@end
