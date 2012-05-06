#ifndef PEARL_WS
#error PEARL_WS used but not enabled.  If you want to use this library, first enable it with #define PEARL_WS in your Pearl prefix file.
#endif

#if ! __has_feature(objc_arc)
#error PEARL_WS requires ARC.  Change your build settings to enable ARC support in your compiler and try again.
#endif

#import "Pearl.h"
#import "PearlWSController.h"
#import "PearlWSStrings.h"
