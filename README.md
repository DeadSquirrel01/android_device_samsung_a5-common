Device configuration for Samsung Galaxy A5 SM-A500 for build CTR Recovery

HOW TO BUILD:

1) Sync CM-12.1 repo (you can also use compressed version, without .repo folder, that you can find on XDA)

2) Copy the device config to source-folder/device/samsung/ and rename it to "a5ultexx"

3) Download CTR recovery sources by opening a terminal window and typing 
$ git clone https://github.com/carliv/carliv_touch_recovery_new.git -b cm-12.1

4) cd to your cm source directory

5) $ . build/envsetup.sh

6) $ lunch full_a5ultexx_eng

7) $ make -j# recoveryimage (change # with your cpu cores or simply type $ make recoveryimage)

8) enjoy CTR recovery compiled by you :)

