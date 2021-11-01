//
//  City.h
//  Offeram
//
//  Created by Dipen Lad on 29/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property(nonatomic,retain) NSString *strCityID;
@property(nonatomic,retain) NSString *strCityName;

@property(nonatomic,retain) NSMutableArray *arrayAllAreas;

@end
