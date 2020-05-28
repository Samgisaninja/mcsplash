include $(THEOS)/makefiles/common.mk

ARCHS = armv7 arm64 arm64e
TWEAK_NAME = mcsplash
mcsplash_FILES = Tweak.xm
mcsplash__CFLAGS = -fobjc-arc
mcsplash_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += mcsplashprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
