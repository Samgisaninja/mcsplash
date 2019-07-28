include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = mcsplashprefs
mcsplashprefs_FILES = MCSRootListController.m
mcsplashprefs_INSTALL_PATH = /Library/PreferenceBundles
mcsplashprefs_FRAMEWORKS = UIKit
mcsplashprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/mcsplashprefs.plist$(ECHO_END)
