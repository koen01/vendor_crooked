# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= ScorpionROM

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/scorpion/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/scorpion/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/scorpion/prebuilt/common/bin/50-lineage.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-lineage.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/addon.d/50-lineage.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/scorpion/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/scorpion/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/scorpion/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/backuptool_ab.sh \
    system/bin/backuptool_ab.functions \
    system/bin/backuptool_postinstall.sh

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Scorpion-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/scorpion/config/permissions/lineage-sysconfig.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/lineage-sysconfig.xml

# Scorpion-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/scorpion/prebuilt/common/etc/init/init.lineage-system.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.lineage-system.rc

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/scorpion/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# This is Scorpion!
PRODUCT_COPY_FILES += \
    vendor/scorpion/config/permissions/org.lineageos.android.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.android.xml

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Include AOSP audio files
include vendor/scorpion/config/aosp_audio.mk

# Include Scorpion audio files
include vendor/scorpion/config/scorpion_audio.mk

ifneq ($(TARGET_DISABLE_LINEAGE_SDK), true)
# Lineage SDK
include vendor/scorpion/config/lineage_sdk_common.mk
endif

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Bootanimation
TARGET_SCREEN_WIDTH ?= 1080
TARGET_SCREEN_HEIGHT ?= 1920
PRODUCT_PACKAGES += \
    bootanimation.zip

# Lineage packages
PRODUCT_PACKAGES += \
    LineageParts \
    LineageSettingsProvider \
    LineageSetupWizard \
    Updater

PRODUCT_COPY_FILES += \
    vendor/scorpion/prebuilt/common/etc/init/init.lineage-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.lineage-updater.rc

# Themes
PRODUCT_PACKAGES += \
    LineageThemesStub \
    ThemePicker

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Extra tools in Lineage
PRODUCT_PACKAGES += \
    7z \
    bash \
    curl \
    getcap \
    htop \
    lib7z \
    nano \
    pigz \
    setcap \
    unrar \
    vim \
    zip

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

PRODUCT_COPY_FILES += \
    vendor/scorpion/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc

# rsync
PRODUCT_PACKAGES += \
    rsync

# Google fonts
PRODUCT_PACKAGES += \
    fonts_customization.xml

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/scorpion/overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/scorpion/overlay/common

PRODUCT_VERSION_MAJOR = v5
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE := 0

ifeq ($(TARGET_VENDOR_SHOW_MAINTENANCE_VERSION),true)
    SCORPION_VERSION_MAINTENANCE := $(PRODUCT_VERSION_MAINTENANCE)
else
    SCORPION_VERSION_MAINTENANCE := 0
endif

# Set SCORPION_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef SCORPION_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "SCORPION_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^SCORPION_||g')
        SCORPION_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(SCORPION_BUILDTYPE)),)
    SCORPION_BUILDTYPE :=
endif

ifdef SCORPION_BUILDTYPE
    ifneq ($(SCORPION_BUILDTYPE), SNAPSHOT)
        ifdef SCORPION_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            SCORPION_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from SCORPION_EXTRAVERSION
            SCORPION_EXTRAVERSION := $(shell echo $(SCORPION_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to SCORPION_EXTRAVERSION
            SCORPION_EXTRAVERSION := -$(SCORPION_EXTRAVERSION)
        endif
    else
        ifndef SCORPION_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            SCORPION_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from SCORPION_EXTRAVERSION
            SCORPION_EXTRAVERSION := $(shell echo $(SCORPION_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to SCORPION_EXTRAVERSION
            SCORPION_EXTRAVERSION := -$(SCORPION_EXTRAVERSION)
        endif
    endif
else
    # If SCORPION_BUILDTYPE is not defined, set to UNOFFICIAL
    SCORPION_BUILDTYPE := UNOFFICIAL
    SCORPION_EXTRAVERSION :=
endif

ifeq ($(SCORPION_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        SCORPION_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(SCORPION_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        SCORPION_BUILDTYPE := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(SCORPION_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            ifeq ($(SCORPION_VERSION_MAINTENANCE),0)
                SCORPION_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(SCORPION_BUILD)
            else
                SCORPION_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(SCORPION_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(S_BUILD)
            endif
        else
            SCORPION_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(SCORPION_BUILD)
        endif
    endif
else
    ifeq ($(SCORPION_VERSION_MAINTENANCE),0)
        ifeq ($(SCORPION_VERSION_APPEND_TIME_OF_DAY),true)
            SCORPION_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d_%H%M%S)-$(SCORPION_BUILDTYPE)$(SCORPION_EXTRAVERSION)-$(SCORPION_BUILD)
        else
            SCORPION_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(SCORPION_BUILDTYPE)$(SCORPION_EXTRAVERSION)-$(SCORPION_BUILD)
        endif
    else
        ifeq ($(SCORPION_VERSION_APPEND_TIME_OF_DAY),true)
            SCORPION_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(SCORPION_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d_%H%M%S)-$(SCORPION_BUILDTYPE)$(SCORPION_EXTRAVERSION)-$(SCORPION_BUILD)
        else
            SCORPION_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(SCORPION_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)-$(SCORPION_BUILDTYPE)$(SCORPION_EXTRAVERSION)-$(SCORPION_BUILD)
        endif
    endif
endif

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/scorpion/build/target/product/security/scorpion

-include vendor/scorpion-priv/keys/keys.mk

SCORPION_DISPLAY_VERSION := $(SCORPION_VERSION)

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
    ifneq ($(SCORPION_BUILDTYPE), UNOFFICIAL)
        ifndef TARGET_VENDOR_RELEASE_BUILD_ID
            ifneq ($(SCORPION_EXTRAVERSION),)
                # Remove leading dash from SCORPION_EXTRAVERSION
                SCORPION_EXTRAVERSION := $(shell echo $(SCORPION_EXTRAVERSION) | sed 's/-//')
                TARGET_VENDOR_RELEASE_BUILD_ID := $(SCORPION_EXTRAVERSION)
            else
                TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
            endif
        else
            TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
        endif
        ifeq ($(SCORPION_VERSION_MAINTENANCE),0)
            SCORPION_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(SCORPION_BUILD)
        else
            SCORPION_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(SCORPION_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(SCORPION_BUILD)
        endif
    endif
endif
endif

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/scorpion/config/partner_gms.mk
