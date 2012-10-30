#import <UIKit/UIKit.h>

@protocol ALValueCellDelegate;

@interface ALValueCell : UITableViewCell {
@private
	id<ALValueCellDelegate> _delegate;
}

@property (nonatomic, assign) id<ALValueCellDelegate> delegate;

- (void)loadValue:(id)value;

- (void)didSelect;

@end

@protocol ALValueCellDelegate <NSObject>
@required
- (void)valueCell:(ALValueCell *)valueCell didChangeToValue:(id)newValue;
@end

@interface ALSwitchCell : ALValueCell {
@private
	UISwitch *switchView;
}

@property (nonatomic, readonly) UISwitch *switchView;

@end

@interface ALCheckCell : ALValueCell {
}

@end

