# RIL
PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/system/lib/libsec-ril.so \
    rild.libargs=-d /dev/smd0 \
    persist.radio.rat_on=combine \
    ril.subscription.types=NV,RUIM \
    ro.ril.telephony.nstrings=7 \
    ro.telephony.default_network=9 \
    ro.product_ship=true \
    ro.ril.transmitpower=true \
    persist.radio.add_power_save=1 \
    persist.radio.no_wait_for_card=1 \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.radio.use_se_table_only=1 \
    persist.radio.jbims=1 \
    telephony.lteOnGsmDevice=1 \
    ro.ril.telephony.mqanelements=6 \
    ro.telephony.ril.config=simactivation

# Netmgrd
PRODUCT_PROPERTY_OVERRIDES += \
    ro.use_data_netmgrd=false \
    persist.data.netmgrd.qos.enable=false

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=320 \
    debug.sf.gpu_comp_tiling=1 \
    debug.mdpcomp.idletime=600 \
    debug.sf.enable_gl_backpressure=1 \
    persist.hwc.mdpcomp.enable=true \
    persist.hwc.ptor.enable=true \
    ro.opengles.version=196608 \
    debug.hwui.use_buffer_age=false

# Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so

# Audio offload
PRODUCT_PROPERTY_OVERRIDES += \
    audio.offload.disable=1

# Fluence
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.audio.fluence.speaker=true \
    persist.vendor.audio.fluence.voicecall=true \
    persist.vendor.audio.fluence.voicerec=false \
    ro.vendor.audio.sdk.fluencetype=none \
    ro.vendor.audio.sdk.ssr=false

# Audio voice recording
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.voice.path.for.pcm.voip=true \
    vendor.voice.playback.conc.disabled=true \
    vendor.voice.record.conc.disabled=true \
    vendor.voice.record.conc.disabled=true \
    vendor.voice.voip.conc.disabled=true

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    debug.stagefright.omx_default_rank.sw-audio=1 \
    debug.stagefright.omx_default_rank=0 \
    mm.enable.smoothstreaming=true \
    vidc.enc.narrow.searchrange=1 \
    media.aac_51_output_enabled=true

# Wi-Fi, Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.direct.interface=p2p0 \
    vendor.qcom.bluetooth.soc=pronto \
    ro.qualcomm.bt.hci_transport=smd \
    ro.bluetooth.dun=true \
    ro.bluetooth.hfp.ver=1.7 \
    ro.bluetooth.sap=true \
    ro.qualcomm.bluetooth.ftp=true \
    ro.qualcomm.bluetooth.hfp=true \
    ro.qualcomm.bluetooth.hsp=true \
    ro.qualcomm.bluetooth.map=true \
    ro.qualcomm.bluetooth.nap=true \
    ro.qualcomm.bluetooth.opp=true \
    ro.qualcomm.bluetooth.pbap=true

# NFC
PRODUCT_PROPERTY_OVERRIDES += \
    ro.nfc.fw_dl_on_boot=false

# Misc.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.chipname=MSM8916 \
    ro.warmboot.capability=1 \
    ro.qualcomm.cabl=0

# GPS
PRODUCT_PROPERTY_OVERRIDES += \
    persist.gps.qmienabled=true \
    persist.gps.qc_nlp_in_use=1 \
    ro.qc.sdk.izat.premium_enabled=0 \
    ro.qc.sdk.izat.service_mask=0x0 \
    ro.gps.agps_provider=1

# Time
PRODUCT_PROPERTY_OVERRIDES += \
    persist.timed.enable=true

# Misc.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sys.fw.dex2oat_thread_count=4 \
    dalvik.vm.dex2oat-flags=--no-watch-dog

# Treble Misc.
PRODUCT_PROPERTY_OVERRIDES += \
    persist.media.treble_omx=false \
    camera.disable_treble=true

# ZRAM
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.zram=true

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    debug.camcorder.disablemeta=true

# Vendor security patch
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.build.security_patch=2017-08-01

# Memory optimizations
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.qti.am.reschedule_service=true
