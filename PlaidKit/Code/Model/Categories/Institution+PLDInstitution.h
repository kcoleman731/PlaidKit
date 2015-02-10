//
//  Institution+PLDInstitution.h
//  PlaidKit
//
//  Created by Kevin Coleman on 2/4/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Institution.h"

typedef NS_ENUM(NSUInteger, PLDInstitutionType) {
    PLDInstitutionTypeAmericanExpress,
    PLDInstitutionTypeBankOfAmerica,
    PLDInstitutionTypeCapitalOne360,
    PLDInstitutionTypeCharlesSchwab,
    PLDInstitutionTypeChase,
    PLDInstitutionTypeCiti,
    PLDInstitutionTypeFidelity,
    PLDInstitutionTypeUSBank,
    PLDInstitutionTypeUSAA,
    PLDInstitutionTypeWellsFargo
};

extern NSString *const PLDInstitutionEntityName;

@interface Institution (PLDInstitution)

NSString *PLDInstitutionWithType(PLDInstitutionType institutionType);

+ (Institution *)institutionWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context;

@end
