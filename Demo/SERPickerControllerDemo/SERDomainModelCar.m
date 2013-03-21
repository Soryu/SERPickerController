//
//  SERDomainModelCar.m
//  SERPickerControllerDemo
//
//  Created by Stanley Rost on 21.03.13.
//  Copyright (c) 2013 Stanley Rost. All rights reserved.
//

#import "SERDomainModelCar.h"

@interface SERDomainModelCar()

@end

@implementation SERDomainModelCar

+ (instancetype)carOfType:(CAR_TYPE)type
{
  SERDomainModelCar *car = [SERDomainModelCar new];
  car.type = type;

  return car;
}

+ (NSString *)stringForType:(CAR_TYPE)type
{
  NSString *string = nil;
  switch (type)
  {
    case CAR_TYPE_PORSCHE:       string = @"Porsche";       break;
    case CAR_TYPE_MERCEDES_BENZ: string = @"Mercedes Benz"; break;
    case CAR_TYPE_BMW:           string = @"BMW";           break;
    case CAR_TYPE_VW:            string = @"VW";            break;
    case CAR_TYPE_AUDI:          string = @"Audi";          break;
    case CAR_TYPE_LOTUS:         string = @"Lotus";         break;
  }
  
  NSAssert(string, @"unknown type");
  
  return string;
}

- (id)copyWithZone:(NSZone *)zone
{
  SERDomainModelCar *copy = [[self class] new];

  if (copy)
  {
    copy.type = self.type;
  }

  return copy;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"Car: %@", [self.class stringForType:self.type]];
}

@end
