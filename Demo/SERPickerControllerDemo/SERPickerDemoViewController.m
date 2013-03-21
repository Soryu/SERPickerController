//
//  SERPickerDemoViewController.m
//  SERPickerControllerDemo
//
//  Created by Stanley Rost on 21.03.13.
//  Copyright (c) 2013 Stanley Rost. All rights reserved.
//

#import "SERPickerDemoViewController.h"
#import "SERDomainModelCar.h"
#import "SERPickerController.h"

@interface SERPickerDemoViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) SERDomainModelCar *pickedCar;

@end

@implementation SERPickerDemoViewController

- (void)loadView
{
  self.view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
  
  UIButton *buttonPickACar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [buttonPickACar setTitle:@"Pick a car" forState:UIControlStateNormal];
  [buttonPickACar addTarget:self action:@selector(buttonPickACarPressed:) forControlEvents:UIControlEventTouchUpInside];
  [buttonPickACar sizeToFit];
  buttonPickACar.center = CGPointMake(50.0, 50.0);
  buttonPickACar.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin  |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin   |
    UIViewAutoresizingFlexibleBottomMargin;
  
  self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 30.0)];
  self.label.text = @"Press the button and choose a value…";
  self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  
  [self.view addSubview:self.label];
  [self.view addSubview:buttonPickACar];
}

- (void)buttonPickACarPressed:(id)sender
{
  // sorted values
  NSArray *values = @[
    [SERDomainModelCar carOfType:CAR_TYPE_AUDI],
    [SERDomainModelCar carOfType:CAR_TYPE_BMW],
    [SERDomainModelCar carOfType:CAR_TYPE_LOTUS],
    [SERDomainModelCar carOfType:CAR_TYPE_MERCEDES_BENZ],
    [SERDomainModelCar carOfType:CAR_TYPE_PORSCHE],
    [SERDomainModelCar carOfType:CAR_TYPE_VW],
  ];
  
  SERPickerController *picker = [[SERPickerController alloc] initWithValues:values transformationBlock:^(SERDomainModelCar *car) {
    return [SERDomainModelCar stringForType:car.type];
  }];

  picker.value = self.pickedCar; // set currently selected value
  picker.toolbar.barStyle = UIBarStyleBlack; // customize toolbar

  [picker presentInView:self.view completion:^(id value){
    self.label.text = [NSString stringWithFormat:@"You picked “%@”", value];
    self.pickedCar = value;
    [picker dismiss];
  }];
}

@end
