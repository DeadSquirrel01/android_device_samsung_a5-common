package org.davis.inputdisabler;

/*
 * Created by Dāvis Mālnieks on 04/10/2015
 */

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Handler;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.Log;

import org.davis.inputdisabler.utils.Constants;
import org.davis.inputdisabler.utils.Device;

import static android.provider.Settings.Secure.DOUBLE_TAP_TO_WAKE;

public class ScreenStateReceiver extends BroadcastReceiver implements SensorEventListener {

    public static final String TAG = "ScreenStateReceiver";

    public static final boolean DEBUG = false;

    android.os.Handler mDozeDisable;

    SensorManager mSensorManager;

    Sensor mSensor;

    // State

    static final int STATE_OFF = 0;

    static final int STATE_ON = 1;

    static final int STATE_DOZE = 2;

    static int mScreenState = STATE_OFF;

    @Override
    public void onReceive(Context context, Intent intent) {

        if(intent == null) return;

        if(DEBUG)
            Log.d(TAG, "Received intent: " + intent.getAction());

        // Check if double tap is enabled
        final int isDoubleTapEnabled = Settings.Secure.getInt(context.getContentResolver(),
                DOUBLE_TAP_TO_WAKE, 0);

        if(DEBUG)
            Log.d(TAG, "Double tap to wake is " +
                    ((isDoubleTapEnabled != 0) ? "" : "not ") + "enabled");

        switch (intent.getAction()) {
            case Intent.ACTION_SCREEN_ON:
                if(DEBUG)
                    Log.d(TAG, "Screen on!");

                // Perform enable->disable->enable sequence
                handleScreenOn(true);

                mScreenState = STATE_ON;
                break;
            case Intent.ACTION_SCREEN_OFF:
                if(DEBUG)
                    Log.d(TAG, "Screen off!");

                // Don't turn off touch when double tap is enabled
                if(isDoubleTapEnabled != 0) {
                    Device.enableKeys(false);
                } else {
                    Device.enableDevices(false);
                }

                // Screen is now off
                mScreenState = STATE_OFF;
                break;
            case Constants.ACTION_DOZE_PULSE_STARTING:
                if(DEBUG)
                    Log.d(TAG, "Doze");

                // Doze is active
                mScreenState = STATE_DOZE;

                mDozeDisable = new Handler();
                Runnable runnable = new Runnable() {
                    @Override
                    public void run() {
                        switch (mScreenState) {
                            case STATE_DOZE:
                                if(DEBUG)
                                    Log.d(TAG, "Stopped dozing, disable inputs");

                                // Screen is off now
                                mScreenState = STATE_OFF;

                                // Don't turn off touch when double tap is enabled
                                if(isDoubleTapEnabled != 0) {
                                    Device.enableKeys(false);
                                } else {
                                    Device.enableDevices(false);
                                }
                                break;
                            case STATE_ON:
                                if(DEBUG)
                                    Log.d(TAG, "Screen was turned on while dozing");
                                break;
                            case STATE_OFF:
                                if(DEBUG)
                                    Log.d(TAG, "Screen was turned off while dozing");
                                break;

                        }
                    }
                };
                mDozeDisable.postDelayed(runnable, Constants.DOZING_TIME);

                // Don't enable touch keys when dozing
                // Perform enable->disable->enable sequence
                handleScreenOn(false);
                break;
            case TelephonyManager.ACTION_PHONE_STATE_CHANGED:
                if(DEBUG)
                    Log.d(TAG, "Phone state changed!");

                final TelephonyManager telephonyManager =
                        (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);

                switch (telephonyManager.getCallState()) {
                    case TelephonyManager.CALL_STATE_OFFHOOK:
                        mSensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
                        mSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY);
                        mSensorManager.registerListener(this, mSensor, 3);
                        break;
                    case TelephonyManager.CALL_STATE_IDLE:
                        if(mSensorManager != null) {
                            mSensorManager.unregisterListener(this);
                        }

			            if(mScreenState != STATE_ON) {
                            handleScreenOn(true);

                            mScreenState = STATE_ON;
			            }
                        break;
                }
                break;
        }
    }

    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
        if(sensorEvent.values[0] == 0.0f) {
            if(DEBUG)
                Log.d(TAG, "Proximity: screen off");

            Device.enableDevices(false);

	        // Screen is off no
	        mScreenState = STATE_OFF;
        } else {
            if(DEBUG)
                Log.d(TAG, "Proximity: screen on");

            handleScreenOn(true);

            mScreenState = STATE_ON;
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int i) {

    }

    // Handles screen on
    private void handleScreenOn(boolean keys) {
        // Enable keys
        if(keys)
            Device.enableKeys(true);

        // Perform enable->disable->enable sequence
        Device.enableTouch(true);
        Device.enableTouch(false);
        Device.enableTouch(true);
    }

}
