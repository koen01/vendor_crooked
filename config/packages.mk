# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    librsjni

# StatiX Packages
PRODUCT_PACKAGES += \
    CustomDoze \
    RepainterServicePriv \
    ThemePicker \
    SimpleDeviceConfig \
    StatiXOSWalls \
    QuickAccessWallet

# Ota updater
PRODUCT_PACKAGES += \
    Updater

# App overrides
PRODUCT_PACKAGES += \
    StatixSystemUI \
    StatixSettings

# Preopt StatixSystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    StatixSystemUI

# Google Camera GO
PRODUCT_PACKAGES += \
    GoogleCameraGo

# Google Pixel Launcher
ifeq ($(INCLUDE_PIXEL_LAUNCHER),true)
PRODUCT_PACKAGES += \
    PixelLauncher
endif

# Updaters
ifeq ($(CROOKED_BUILD_TYPE),OFFICIAL)
PRODUCT_PACKAGES += \
    Updater
else ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_PACKAGES += \
    LocalUpdater
endif

# Some useful shell based utilities for Android
PRODUCT_PACKAGES += \
    htop \
    nano \
    vim

# Charger images
PRODUCT_PACKAGES += \
    charger_res_images

-include vendor/crooked/config/overlay.mk
