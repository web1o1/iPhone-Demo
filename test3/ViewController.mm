//
//  ViewController.m
//  test3
//
//  Created by Funwish on 2014/2/25.
//  Copyright (c) 2014年 Funwish. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setUser:@"amway_mcom"];
    [self setLogLocation:YES];
    [self setDecodeBarCode:NO];
    [self setRecognizeSimilar:YES];
    [self setRecognizePrefer:kp_accurate];
    [self setRecognizeMode:km_sequence];
    
    // viewController Settings
    [self setDelegate:self];
    [self setInterest:CGRectMake(8, 36, 304, 384)
           withBorder:[UIColor clearColor]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadKernelData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unload data to reduce memory usage when view not in use
    [self unloadKernelData];
}

-(void)recognizeMatched:(NSArray*)names withImage:(UIImage*)image
{
    UIAlertView *alert =[ [UIAlertView alloc]
                         initWithTitle:@"Matched"
                         message:[names objectAtIndex:0]
                         delegate:self cancelButtonTitle:@"cancel"
                         otherButtonTitles:nil];
    // need to call recognizeContinue when alert dismissed to continue scan
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notifyError:(KernelError)error
{
    NSLog(@"error %d", error);
}

@end
