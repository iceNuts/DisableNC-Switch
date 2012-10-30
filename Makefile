GO_EASY_ON_ME=1
include theos/makefiles/common.mk

TWEAK_NAME = DisableNCSwitch
DisableNCSwitch_FILES = Tweak.xm
DisableNCSwitch_FRAMEWORKS = UIKit CoreGraphics QuartzCore Foundation
DisableNCSwitch_PRIVATE_FRAMEWORKS=AppSupport

SUBPROJECTS=DisableNC

TARGET_IPHONEOS_DEPLOYMENT_VERSION = 5.0

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

