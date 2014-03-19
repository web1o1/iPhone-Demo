//
//  DSViewController.m
//  image_recognition
//
//  Created by linfish on 13/9/26.
//  Copyright (c) 2013年 linfish. All rights reserved.
//

#import "DSViewController.h"

@interface DSViewController ()
@property (nonatomic, retain) UIView *scanBar;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSDate *start;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) CGRect region;
@end

@implementation DSViewController
@synthesize scanBar;
@synthesize indicator;
@synthesize start;
@synthesize region;
@synthesize color;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setUser:@"demo"];
        [self setLogLocation:YES];
        [self setRecognizeSimilar:YES];
        [self setRecognizeMode:km_online];
        [self setRecognizePrefer:kp_speed];

        [self setDelegate:self];

        self.region = CGRectZero;
        self.color = [UIColor colorWithRed:0.1 green:0.63 blue:0.9 alpha:1.0];

        [self setInterest:self.region withBorder:self.color];
        //Load ofline data
        //[self loadKernelData];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (CGRectEqualToRect(region, CGRectZero)) {
        region = self.view.bounds;
    }
    self.scanBar = [[UIView alloc] initWithFrame:CGRectMake(region.origin.x, region.origin.y, region.size.width, 3.0)];
    [self.scanBar setBackgroundColor:self.color];
    [self.scanBar setHidden:YES];
    [self.view addSubview:self.scanBar];

    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.center = CGPointMake(region.origin.x + region.size.width / 2.0, region.origin.y + region.size.height / 2.0);
    [self.view addSubview:self.indicator];

    NSString *logoPath = [[NSBundle mainBundle] pathForResource:@"funwish_logo" ofType:@"png"];
    UIImage *logo = [UIImage imageWithContentsOfFile:logoPath];
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 8.0, 72.0, 24.0)];
    logoView.image = logo;
    [self.view addSubview:logoView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.scanBar.hidden = YES;
    [self.view.layer removeAllAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Animation Control
- (void)runAnimation
{
    self.scanBar.frame = CGRectMake(region.origin.x, region.origin.y, region.size.width, 3.0);
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:UIViewAnimationOptionRepeat |
                                UIViewAnimationOptionCurveLinear |
                                UIViewAnimationOptionAutoreverse |
                                UIViewAnimationOptionOverrideInheritedCurve |
                                UIViewAnimationOptionOverrideInheritedDuration
                     animations:^{ self.scanBar.frame = CGRectMake(region.origin.x, region.origin.y + region.size.height, region.size.width, 3.0); }
                     completion:nil];
}

- (void)showAnimation
{
    if (self.scanBar.hidden == YES) {
        [self runAnimation];
        self.scanBar.hidden = NO;
        self.start = [NSDate date];
    }
}

- (void)hideAnimation
{
    self.scanBar.hidden = YES;
    [self.view.layer removeAllAnimations];
}

#pragma mark - ScanDelegate
- (void)recognizeMatched:(NSArray*)names withImage:(UIImage*)image
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.start];
    UIAlertView *alert = nil;
    if ([names count] == 1) {
        alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Matched - %.2f", interval]
                                           message:[names objectAtIndex:0]
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    } else {
        NSString *msg = @"";
        for (int i = 0; i < [names count]; i++) {
            msg = [msg stringByAppendingString:[names objectAtIndex:i]];
            if (i + 1 != [names count]) {
                msg = [msg stringByAppendingString:@"\n"];
            }
        }
        alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Matched - %.2f", interval]
                                           message:msg
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    }

    [alert show];
}

- (void)recognizeSimilar:(NSArray*)names withImage:(UIImage*)image
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.start];
    UIAlertView *alert = nil;
    if ([names count] == 1) {
        alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Similar - %.2f", interval]
                                           message:[names objectAtIndex:0]
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    } else {
        NSString *msg = @"";
        for (int i = 0; i < [names count]; i++) {
            msg = [msg stringByAppendingString:[names objectAtIndex:i]];
            if (i + 1 != [names count]) {
                msg = [msg stringByAppendingString:@"\n"];
            }
        }
        alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Similar - %.2f", interval]
                                           message:msg
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    }

    [alert show];
}

- (void)recognizeFailed:(UIImage*)image
{
    NSLog(@"failed");
}

- (void)recognizeBegin
{
    [self showAnimation];
}

- (void)recognizeEnd
{
    // do nothing
}

// notify when detecting errors
- (void)notifyError:(KernelError)error
{
    NSLog(@"error %d", error);
}

#pragma mark - UIAlertViewDelegate
- (void)willPresentAlertView:(UIAlertView *)alertView  // before animation and showing view
{
    [self hideAnimation];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self recognizeContinue];
    }
}
@end
