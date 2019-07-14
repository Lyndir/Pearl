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

@interface PearlEMail()<MFMailComposeViewControllerDelegate>
@end

@implementation PearlEMail {
}

@synthesize composer = _composer;

+ (BOOL)canSendMail {

    return [MFMailComposeViewController canSendMail];
}

+ (NSMutableArray *)activeComposers {

    static NSMutableArray *activeComposers = nil;
    if (!activeComposers)
        activeComposers = [[NSMutableArray alloc] initWithCapacity:1];

    return activeComposers;
}

+ (void)sendEMailTo:(NSString *)recipient fromVC:(UIViewController *)viewController {

    [self sendEMailTo:recipient fromVC:viewController subject:nil body:nil];
}

+ (void)sendEMailTo:(NSString *)recipient fromVC:(UIViewController *)viewController
            subject:(NSString *)subject body:(NSString *)body {

    [self sendEMailTo:recipient fromVC:viewController subject:subject body:body attachments:nil];
}

+ (void)sendEMailTo:(NSString *)recipient fromVC:(UIViewController *)viewController
            subject:(NSString *)subject body:(NSString *)body attachments:(PearlEMailAttachment *)attachment, ... {

    [[[self alloc] initForEMailTo:recipient subject:subject body:body attachmentsArray:va_array(attachment)]
            showComposerForVC:viewController];
}

- (id)initForEMailTo:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body
         attachments:(PearlEMailAttachment *)attachments, ... {

    return [self initForEMailTo:recipient subject:subject body:body attachmentsArray:va_array(attachments)];
}

- (id)initForEMailTo:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body attachmentsArray:(NSArray *)attachments {

    if (!(self = [super init]))
        return nil;

    NSAssert([NSThread currentThread].isMainThread, @"Should be on the main thread; was on thread: %@", [NSThread currentThread].name);

    self.composer = [MFMailComposeViewController new];
    if (!self.composer) {
        wrn(@"Failed to create MFMailComposeViewController.");
        return nil;
    }

    [self.composer setMailComposeDelegate:self];
    if (recipient)
        [self.composer setToRecipients:@[ recipient ]];
    [self.composer setSubject:subject];
    [self.composer setMessageBody:body isHTML:NO];

    for (PearlEMailAttachment *attachment in attachments)
        [self.composer addAttachmentData:attachment.content
                                mimeType:attachment.mimeType
                                fileName:attachment.fileName];

    return self;
}

- (void)showComposer {

    [self showComposerForVC:nil];
}

- (void)showComposerForVC:(UIViewController *)vc {

    if (!vc) {
        UIWindow *window = UIApp.windows[0];
        vc = window.rootViewController;
        while ([vc presentedViewController])
            vc = [vc presentedViewController];
    }
    if ([vc presentedViewController])
    wrn(@"Won't be able to show composer, given VC is already presenting something.");

    // Remove custom font for navigation bar: Causes a bug in iOS when presenting the MFMailComposeViewController.
    NSMutableDictionary *navBarTitleAttributes = [[UINavigationBar appearance] titleTextAttributes].mutableCopy;
    UIFont *navBarTitleFont = navBarTitleAttributes[NSFontAttributeName];
    navBarTitleAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:navBarTitleFont.pointSize];
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleAttributes];

    // Present the MFMailComposeViewController.
    [vc presentViewController:self.composer animated:YES completion:^{
        // Add back our custom font.
        if (navBarTitleFont) {
            navBarTitleAttributes[NSFontAttributeName] = navBarTitleFont;
            [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleAttributes];
        }
    }];

    [[PearlEMail activeComposers] addObject:self];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    if (error)
        err(@"Error composing mail message: %@", [error fullDescription]);

    switch (result) {
        case MFMailComposeResultSaved:
        case MFMailComposeResultSent:
        case MFMailComposeResultCancelled:
            break;

        case MFMailComposeResultFailed: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"A problem occurred with your E-Mail."
                                                                           message:[error localizedDescription]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:PearlStrings.get.commonButtonOkay style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {
                                                        [controller dismissViewControllerAnimated:YES completion:nil];
                                                        [[PearlEMail activeComposers] removeObject:self];
                                                    }]];
            [alert addAction:[UIAlertAction actionWithTitle:PearlStrings.get.commonButtonRetry style:UIAlertActionStyleDefault handler:nil]];
            [controller presentViewController:alert animated:YES completion:nil];
            return;
        }
    }

    [controller dismissViewControllerAnimated:YES completion:nil];
    [[PearlEMail activeComposers] removeObject:self];
}

@end

@implementation PearlEMailAttachment

- (id)initWithContent:(NSData *)content mimeType:(NSString *)mimeType fileName:(NSString *)fileName {

    if (!(self = [super init]))
        return nil;

    self.content = content;
    self.mimeType = mimeType;
    self.fileName = fileName;

    return self;
}

@end

#endif
