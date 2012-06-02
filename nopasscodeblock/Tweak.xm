@interface SBAwayController : NSObject
- (void)_clearBlockedState;
- (void)clearBlockedStateAndUpdateUI:(BOOL)update;
@end

%hook SBAwayController

- (void)_finishedUnlockAttemptWithStatus:(BOOL)status {
    if (!status) {
        if ([self respondsToSelector:@selector(clearBlockedStateAndUpdateUI:)]) {
            [self clearBlockedStateAndUpdateUI:YES];
        } else {
            [self _clearBlockedState];
        }
    }

    %orig;
}

%end
