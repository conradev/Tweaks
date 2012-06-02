#include <substrate.h>

@interface TPLCDTextView : UIView
@property (nonatomic, retain) NSString *text;
@end

extern "C" CFStringRef UIDateFormatStringForFormatTypeForLocale(CFLocaleRef locale, CFStringRef dateFormat);
static CFStringRef (*original_UIDateFormatStringForFormatTypeForLocale)(CFLocaleRef locale, CFStringRef dateFormat);

static BOOL updatingLabels;

%hook SBAwayDateView

- (void)updateClock {
    %orig;
    NSTimer *dateTimer = MSHookIvar<NSTimer *>(self, "_dateTimer");
    [dateTimer invalidate];
    [dateTimer release];

    MSHookIvar<NSTimer *>(self, "_dateTimer") = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateClock) userInfo:nil repeats:NO] retain];
}

- (void)updateLabels {
    updatingLabels = YES;
	%orig;
    updatingLabels = NO;
}

%end

CFStringRef custom_UIDateFormatStringForFormatTypeForLocale(CFLocaleRef locale, CFStringRef dateFormat) {
    CFStringRef orig = original_UIDateFormatStringForFormatTypeForLocale(locale, dateFormat);

    if (CFStringCompare(dateFormat, CFSTR("UINoAMPMTimeFormat"), 0) == kCFCompareEqualTo && updatingLabels) {
        return (CFStringRef)[(NSString *)orig stringByAppendingString:@":ss"];
    }

    return orig;
}

%ctor {
    updatingLabels = NO;
    MSHookFunction(UIDateFormatStringForFormatTypeForLocale, custom_UIDateFormatStringForFormatTypeForLocale, &original_UIDateFormatStringForFormatTypeForLocale);
    %init;
}
