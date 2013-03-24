//
//  SERPickerController.m
//
//  Copyright (c) 2013 Stanley Rost
//

#import "SERPickerController.h"

@interface SERPickerController () <UIPickerViewDataSource, UIPickerViewDelegate>
{
  NSArray *_originalValues;
  NSArray *_transformedValues;
  NSString *_selectedValue;
}

@property (nonatomic, copy) SERPickerCompletionBlock completionBlock;

@end

static const CGFloat kPickerHeight  = 216.0;
static const CGFloat kToolbarHeight =  44.0;

static const NSTimeInterval kAnimationDuration = 0.25;

@implementation SERPickerController

- (id)initWithValues:(NSArray *)values transformationBlock:(SERPickerTransformationBlock)transformationBlock;
{
  self = [super init];
  if (self)
  {
    self.transformationBlock = transformationBlock;
    [self setValues:values];
    [self view]; // to make sure view has been loaded, so customization can be done right away
  }
  return self;
}


#pragma mark UI

- (void)loadView
{
  self.pickerView = [UIPickerView new];
  self.pickerView.showsSelectionIndicator = YES;
  self.pickerView.dataSource = self;
  self.pickerView.delegate   = self;
  
  self.toolbar = [UIToolbar new];
  self.toolbar.items = @[

    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
      style:UIBarButtonItemStyleBordered
      target:self action:@selector(cancelButtonPressed:)],

    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
      target:nil
      action:NULL],

    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
      target:self
      action:@selector(doneButtonPressed:)],
  ];
  
  self.capturingView = [UIView new];
  self.capturingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
  [self.capturingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonPressed:)]];
  
  self.view = [UIView new];
  [self.view addSubview:self.capturingView];
  [self.view addSubview:self.toolbar];
  [self.view addSubview:self.pickerView];
}

// FIXME support for landscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskPortrait;
}


#pragma mark Interface

- (void)setValues:(NSArray *)originalValues
{
  NSAssert([originalValues count] > 0, @"values cannot be nil or empty");
  
  NSMutableArray *strings = [NSMutableArray array];

  for(id originalValue in originalValues)
  {
    NSString *string = self.transformationBlock(originalValue);
    NSAssert([string isKindOfClass:[NSString class]], @"transformed value must be a string");

    [strings addObject:string];
  }
  
  _originalValues = originalValues;
  _transformedValues = strings;
  _selectedValue = nil;

  [self.pickerView reloadAllComponents];
  [self updatePickerSelection];
}

- (void)setValue:(id)originalValue
{
  if (originalValue)
  {
    _selectedValue = self.transformationBlock(originalValue);
  }
  else
  {
    _selectedValue = nil;
  }

  [self updatePickerSelection];
}

- (void)presentInView:(UIView *)presentingView completion:(SERPickerCompletionBlock)completionBlock
{
  self.completionBlock = completionBlock;
  
  self.view.alpha = 0.0;
  [self updatePickerSelection];
  
  self.view.frame = presentingView.bounds;
  self.capturingView.frame = self.view.bounds;
  
  CGFloat viewWidth  = self.view.frame.size.width;
  CGFloat viewHeight = self.view.frame.size.height;
  
  self.toolbar.frame    = CGRectMake(0.0, viewHeight - kToolbarHeight - kPickerHeight, viewWidth, kToolbarHeight);
  self.pickerView.frame = CGRectMake(0.0, viewHeight - kPickerHeight, viewWidth, kPickerHeight);
  
  [presentingView addSubview:self.view];

  self.toolbar.transform    = CGAffineTransformMakeTranslation(0.0, kToolbarHeight + kPickerHeight);
  self.pickerView.transform = CGAffineTransformMakeTranslation(0.0, kToolbarHeight + kPickerHeight);
  
  [UIView animateWithDuration:kAnimationDuration
    delay:0.0
    options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
    animations:^{
      self.view.alpha = 1.0;
      self.toolbar.transform    = CGAffineTransformIdentity;
      self.pickerView.transform = CGAffineTransformIdentity;
    }
    completion:NULL
  ];
  }

- (void)dismiss
{
  [UIView animateWithDuration:kAnimationDuration
    delay:0.0
    options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
    animations:^{
      self.view.alpha = 0.0;
      self.toolbar.transform    = CGAffineTransformMakeTranslation(0.0, kToolbarHeight + kPickerHeight);
      self.pickerView.transform = CGAffineTransformMakeTranslation(0.0, kToolbarHeight + kPickerHeight);
    }
    completion:^(BOOL finished) {
      [self.view removeFromSuperview];
    }
  ];
}


#pragma mark Actions

- (void)doneButtonPressed:(id)sender
{
  NSInteger index = [self.pickerView selectedRowInComponent:0];
  id pickedValue = [_transformedValues objectAtIndex:index];
  id reverseTransformedValue = nil;

  if (pickedValue)
  {
    for(id originalValue in _originalValues)
    {
      NSString *transformedValue = self.transformationBlock(originalValue);
      if ([transformedValue isEqualToString:pickedValue])
      {
        reverseTransformedValue = originalValue;
        break;
      }
    }
  }

  self.completionBlock(reverseTransformedValue);
}

- (void)cancelButtonPressed:(id)sender
{
  self.completionBlock(nil);
}


#pragma mark Helpers

- (void)updatePickerSelection
{
  if (!self.pickerView || [_transformedValues count] == 0)
    return;
  
  NSInteger index = 0;
  if (_selectedValue)
  {
    NSInteger indexCandidate = [_transformedValues indexOfObject:_selectedValue];
    if (indexCandidate != NSNotFound)
      index = indexCandidate;
  }
  
  [self.pickerView selectRow:index inComponent:0 animated:NO];
}


#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return [_transformedValues count];
}


#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return _transformedValues[row];
}

@end
