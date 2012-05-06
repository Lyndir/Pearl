#ifndef PEARL_MEDIA
#error PEARL_MEDIA used but not enabled.  If you want to use this library, first enable it with #define PEARL_MEDIA in your Pearl prefix file.
#endif

#if ! __has_feature(objc_arc)
#error PEARL_MEDIA requires ARC.  Change your build settings to enable ARC support in your compiler and try again.
#endif

#import "Pearl.h"
#import "PearlAudioController.h"
