//
//  SERDomainModelCar.h
//  SERPickerControllerDemo
//
//  Created by Stanley Rost on 21.03.13.
//  Copyright (c) 2013 Stanley Rost. All rights reserved.
//

typedef enum {
  CAR_TYPE_PORSCHE,
  CAR_TYPE_MERCEDES_BENZ,
  CAR_TYPE_BMW,
  CAR_TYPE_VW,
  CAR_TYPE_AUDI,
  CAR_TYPE_LOTUS
} CAR_TYPE;

@interface SERDomainModelCar : NSObject

+ (instancetype)carOfType:(CAR_TYPE)type;
+ (NSString *)stringForType:(CAR_TYPE)type;

@property (nonatomic) CAR_TYPE type;

@end
