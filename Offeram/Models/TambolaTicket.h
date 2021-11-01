//
//  TambolaTicket.h
//  Offeram
//
//  Created by Innovative Iteration on 27/04/20.
//  Copyright © 2020 Accrete. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TambolaTicket : NSObject

@property(nonatomic,retain) NSString *strTambolaTicketID;
@property(nonatomic,retain) NSString *strTambolaTicketImageURL;
@property(nonatomic,retain) NSString *strTambolaTicketTitle;
@property(nonatomic,retain) NSString *strTambolaTicketDescription;
@property(nonatomic,assign) BOOL boolIsAlreadyRegistered;
@property(nonatomic,retain) NSString *strTambolaTicketPrice;
@property(nonatomic,assign) BOOL boolIsTambolaRequiredRegistration;
@property(nonatomic,retain) NSString *strTambolaTicketPDFURL;
@property(nonatomic,retain) NSString *strTambolaTicketKnowMoreURL;

@end

