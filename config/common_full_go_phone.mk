# Set Lineage specific identifier for Android Go enabled products
PRODUCT_TYPE := go

# Inherit full common stuff
$(call inherit-product, vendor/scorpion/config/common_full_phone.mk)
