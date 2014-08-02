//
//  RootViewController.m
//  Coaster
//
//  Created by Samuel Edson on 7/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "RootViewController.h"

#import "TrailView.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if ( ! self) { return nil; }
  
  CGRect topBarFrame = CGRectMake(0, 0, self.view.frame.size.width, 20);
  UIView *topBar = [[UIView alloc] initWithFrame:topBarFrame];
  topBar.backgroundColor = [UIColor whiteColor];

  [self.view addSubview:[[TrailView alloc] initWithFrame:self.view.frame]];
  [self.view addSubview:topBar];
  
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
