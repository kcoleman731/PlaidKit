//
//  Institution+PLDInstitution.m
//  PlaidKit
//
//  Created by Kevin Coleman on 2/4/15.
//  Copyright (c) 2015 Kevin Coleman. All rights reserved.
//

#import "Institution+PLDInstitution.h"
#import "Product+PLDProduct.h"
#import "PLDUtilities.h"

NSString *const PLDInstitutionCredentialsKey = @"credentials";
NSString *const PLDInstitutionHasMFAKey = @"has_mfa";
NSString *const PLDInstitutionIdentifierKey = @"id";
NSString *const PLDInstitutionMFAKey = @"mfa";
NSString *const PLDInstitutionNameKey = @"name";
NSString *const PLDInstitutionProductsKey = @"products";

/*
{
    "credentials": {
        "password": "Password",
        "username": "User ID"
    },
    "has_mfa": false,
    "id": "5301a9d704977c52b60000db",
    "mfa": [],
    "name": "American Express",
    "type": "amex",
    "products": [
                 "connect",
                 "balance"
                 ]
},
*/
@implementation Institution (PLDInstitution)

NSString *const PLDInstitutionEntityName = @"Institution";

+ (Institution *)institutionWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    NSLog(@"Data: %@", data);
    Institution *institution = [NSEntityDescription insertNewObjectForEntityForName:PLDInstitutionEntityName inManagedObjectContext:context];
    if (institution) {
        institution.hasMFA = data[PLDInstitutionHasMFAKey];
        institution.identifier = data[PLDInstitutionIdentifierKey] ;
        institution.name = data[PLDInstitutionNameKey];
        institution.type = data[PLDInstitutionTypeKey];
        institution.products = [Product productWithData:data[PLDInstitutionProductsKey] context:context];
    }
    return institution;
}

NSString *PLDInstitutionWithType(PLDInstitutionType institutionType)
{
    switch (institutionType) {
        case PLDInstitutionTypeAmericanExpress:
            return @"amex";
            break;
            
        case PLDInstitutionTypeBankOfAmerica:
            return @"bofa";
            break;
            
        case PLDInstitutionTypeCapitalOne360:
            return @"capone360";
            break;
            
        case PLDInstitutionTypeCharlesSchwab:
            return @"schwab";
            break;
            
        case PLDInstitutionTypeChase:
            return @"chase";
            break;
            
        case PLDInstitutionTypeCiti:
            return @"citi";
            break;
            
        case PLDInstitutionTypeFidelity:
            return @"fidelity";
            break;
            
        case PLDInstitutionTypeUSBank:
            return @"us";
            break;
            
        case PLDInstitutionTypeUSAA:
            return @"usaa";
            break;
            
        case PLDInstitutionTypeWellsFargo:
            return @"wells";
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nInstitution: %@\nName: %@\nType: %@\nProducts: %@\nHasMFA: %@", self.identifier, self.name, self.type, self.products, self.hasMFA];
    
}
@end
