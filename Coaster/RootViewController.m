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
  
  CGRect topBarFrame = CGRectMake(0, 0, self.view.frame.size.width, 24);
  UIView *topBar = [[UIView alloc] initWithFrame:topBarFrame];
//  topBar.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:1 alpha:1];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
