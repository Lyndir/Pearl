#ifndef PEARL_CRYPTO
#error PEARL_CRYPTO used but not enabled.  If you want to use this library, first enable it with #define PEARL_CRYPTO in your Pearl prefix file.
#endif

#if ! __has_feature(objc_arc)
#error PEARL_CRYPTO requires ARC.  Change your build settings to enable ARC support in your compiler and try again.
#endif

#import "Pearl.h"
#import "PearlCryptUtils.h"
#import "PearlKeyChain.h"
#import "PearlRSAKey.h"
#import "PearlSCrypt.h"
