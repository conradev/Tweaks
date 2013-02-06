@interface SBDeviceLockController : NSObject
+ (instancetype)sharedController;
- (void)_clearBlockedState;
@end

@interface SBAwayController : NSObject
- (void)_clearBlockedState;
- (void)clearBlockedStateAndUpdateUI:(BOOL)update;
@end

%hook SBAwayController

- (void)_finishedUnlockAttemptWithStatus:(BOOL)status {
    if (!status) {
        if ([self respondsToSelector:@selector(clearBlockedStateAndUpdateUI:)]) {
            [self clearBlockedStateAndUpdateUI:YES];
        } else if ([self respondsToSelector:@selector(_clearBlockedState)]) {
            [self _clearBlockedState];
        } else {
            [[%c(SBDeviceLockController) sharedController] _clearBlockedState];
        }
    }

    %orig;
}

%end
