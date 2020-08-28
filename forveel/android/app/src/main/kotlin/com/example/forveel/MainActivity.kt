package com.example.forveel

import android.content.pm.PackageManager
import android.os.Build
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"
 var myresult:MethodChannel.Result?=null
var accesscode=123;
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(ShimPluginRegistry(flutterEngine))
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(call.method.equals("StartSecondActivity")){
                checkpermiss(result)
            }
            else{
                result.notImplemented()
            }
        }
    }
    fun checkpermiss(result:MethodChannel.Result)
    {
        myresult=result;
        if(Build.VERSION.SDK_INT>=23)
        {
            if(ActivityCompat.checkSelfPermission(this,android.Manifest.permission.ACCESS_FINE_LOCATION)!=PackageManager.PERMISSION_GRANTED)
            {
                requestPermissions(arrayOf(android.Manifest.permission
                        .ACCESS_FINE_LOCATION),accesscode)
                return
            }
        }
        gotpermiison()
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when(requestCode)
        {
            accesscode->
            {
                if(grantResults[0]==PackageManager.PERMISSION_GRANTED)
                {
                    gotpermiison()
                }
                else
                {
                    myresult!!.success("failed")
                }
            }
        }
    }

    //if(gotpermisson)
    fun gotpermiison()
    {
 myresult!!.success("success")

    }

    override fun onDestroy() {
        flutterEngine?.platformViewsController?.onFlutterViewDestroyed()
        super.onDestroy()
    }
}