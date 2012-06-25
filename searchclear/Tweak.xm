@interface AddressView : UIView
- (void)clearSearchTextField;
@end

%hook AddressView

- (void)search {
	%orig;
    [self clearSearchTextField];
}

%end
