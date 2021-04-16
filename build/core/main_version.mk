# ScorpionROM System Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.scorpion.version=$(SCORPION_VERSION) \
    ro.scorpion.releasetype=$(SCORPION_BUILDTYPE) \
    ro.scorpion.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.modversion=$(SCORPION_VERSION) \
    ro.scorpionlegal.url=https://lineageos.org/legal

# ScorpionROM Platform Display Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.scorpion.display.version=$(SCORPION_DISPLAY_VERSION)

# ScorpionROM Platform SDK Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.scorpion.build.version.plat.sdk=$(LINEAGE_PLATFORM_SDK_VERSION)

# ScorpionROM Platform Internal Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.scorpion.build.version.plat.rev=$(SCORPION_PLATFORM_REV)

# Only use stock build fingerprint for Google Play Services
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.stock_fingerprint=$(BUILD_FINGERPRINT)
