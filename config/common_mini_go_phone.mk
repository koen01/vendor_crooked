# Set Lineage specific identifier for Android Go enabled products
PRODUCT_TYPE := go

# Inherit mini common stuff
$(call inherit-product, vendor/scorpion/config/common_mini_phone.mk)
