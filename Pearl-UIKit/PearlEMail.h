/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

//
//  PearlEMail
//
//  Created by Maarten Billemont on 2012-08-25.
//  Copyright 2012 lhunath (Maarten Billemont). All rights reserved.
//

#ifdef PEARL_WITH_MESSAGEUI

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface PearlEMailAttachment : NSObject

@property (nonatomic, strong) NSData   *content;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSString *fileName;

- (id)initWithContent:(NSData *)content mimeType:(NSString *)mimeType fileName:(NSString *)fileName;

@end

@interface PearlEMail : NSObject

@property (nonatomic, strong) MFMailComposeViewController *composer;

+ (BOOL)canSendMail;

+ (void)sendEMailTo:(NSString *)recipient;
+ (void)sendEMailTo:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body;
+ (void)sendEMailTo:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body
        attachments:(PearlEMailAttachment *)attachment, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initForEMailTo:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body
         attachments:(PearlEMailAttachment *)attachments, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initForEMailTo:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body
    attachmentsArray:(NSArray *)attachments;

- (void)showComposer;
- (void)showComposerForVC:(UIViewController *)vc;

@end

#endif
