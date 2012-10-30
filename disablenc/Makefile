GO_EASY_ON_ME=1
include theos/makefiles/common.mk

BUNDLE_NAME = DisableNC
DisableNC_FILES = DisableNC.xm application.m
DisableNC_INSTALL_PATH = /Library/PreferenceBundles
DisableNC_FRAMEWORKS = UIKit Foundation CoreFoundation
DisableNC_PRIVATE_FRAMEWORKS = Preferences AppSupport
DisableNC_LDFLAGS = -L/$(FW_OBJ_DIR)
DisableNC_LIBRARIES = applist

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DisableNC.plist$(ECHO_END)
