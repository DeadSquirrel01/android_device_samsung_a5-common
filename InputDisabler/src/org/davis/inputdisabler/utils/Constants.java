package org.davis.inputdisabler.utils;

/*
 * Created by Dāvis Mālnieks on 04/10/2015
 */

public final class Constants {

    // Paths to input devices

    public static final String TS_PATH = "/sys/class/input/input2/enabled";

    public static final String TK_PATH = "/sys/class/input/input1/enabled";

    public static final String TK_FORCE_DISABLE = "/sys/class/sec/sec_touchkey/force_disable";

    // Doze

    public static final int DOZING_TIME = 1000 * 5;

    public static final String ACTION_DOZE_PULSE_STARTING = "android.intent.action.DOZE_PULSE_STARTING";
}
