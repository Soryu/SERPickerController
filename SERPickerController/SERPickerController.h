//
//  SERPickerController.h
//
//  Copyright (c) 2013 Stanley Rost
//

typedef NSString *(^SERPickerTransformationBlock)(id);
typedef void (^SERPickerCompletionBlock)(id);

@interface SERPickerController : UIViewController

/**
 * The UI elements are public for customization
 */
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIView *capturingView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, copy) SERPickerTransformationBlock transformationBlock;

/**
 * values: your original value objects, probably domain specific models
 * transformationBlock: id -> NSString
 * Transforms your original values into NSString instances so the picker can display them
 */
- (id)initWithValues:(NSArray *)values transformationBlock:(SERPickerTransformationBlock)transformationBlock;

/**
 * Set the original values for the picker
 * Array elements can be all kinds of object, they will be transformed into NSString instances internally using the transformationBlock
 */
- (void)setValues:(NSArray *)originalValues;

/**
 * Set the current value of the picker, original value, will be transformed using the transformationBlock
 */
- (void)setValue:(id)originalValue;
  
/**
 * Methods to show and hide the picker
 * The completionsBlock will get one of your original values passed or nil if the user cancelled
 */
- (void)presentInView:(UIView *)view completion:(SERPickerCompletionBlock)completionBlock;

/**
 * Calling dismiss will not invoke the completionBlock
 */
- (void)dismiss;

@end
