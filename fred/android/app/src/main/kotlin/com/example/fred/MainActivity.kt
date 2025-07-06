package com.example.fred

import android.os.Bundle
import android.location.GnssStatus
import android.location.LocationManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "gnss_info"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getGnssSatellites") {
                    val locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
                    val gnssStatusCallback = object : GnssStatus.Callback() {
                        override fun onSatelliteStatusChanged(status: GnssStatus) {
                            val satelliteCount = status.satelliteCount
                            val satellites = mutableListOf<String>()

                            for (i in 0 until satelliteCount) {
                                val constellationType = status.getConstellationType(i)
                                val type = when (constellationType) {
                                    GnssStatus.CONSTELLATION_GPS -> "GPS"
                                    GnssStatus.CONSTELLATION_GLONASS -> "GLONASS"
                                    GnssStatus.CONSTELLATION_GALILEO -> "Galileo"
                                    GnssStatus.CONSTELLATION_BEIDOU -> "BeiDou"
                                    GnssStatus.CONSTELLATION_IRNSS -> "NavIC"
                                    else -> "Unknown"
                                }
                                satellites.add(type)
                            }
                            result.success(satellites)
                        }
                    }
                    locationManager.registerGnssStatusCallback(gnssStatusCallback)
                } else {
                    result.notImplemented()
                }
            }
    }
}
