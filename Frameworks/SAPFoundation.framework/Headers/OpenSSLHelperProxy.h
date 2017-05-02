//
//  OpenSSLHelperProxy.h
//  Commons
//
//  Copyright © 2016 SAP SE or an SAP affiliate company. All rights reserved.
//
//  No part of this publication may be reproduced or transmitted in any form or for any purpose
//  without the express permission of SAP SE.  The information contained herein may be changed
//  without prior notice.
//

@interface OpenSSLHelperProxy : NSObject

+(NSData*)createCertificateSigningRequestDataUsingPrivateKeyData:(NSData*)privateKeyData subject:(NSString*)subject;
+(NSData*)pkcs12FromPrivateKeyData:(NSData*)privateKeyData certificateData:(NSData*)certificateData;

@end
