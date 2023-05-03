package com.forestocean.keepdiary

import android.app.Activity
import android.os.Bundle
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.util.Log

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    internal var WRITE_REQUEST_CODE = 77777 //unique request code
    internal var _result: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        //これが無かったっせいでGWの丸一日を無駄にした。許せない
        GeneratedPluginRegistrant.registerWith(flutterEngine!!)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "forestocean/openDocument").setMethodCallHandler { call, result ->

            if (call.method == "getPath") {
                _result = result
                var mime: String? = call.argument<String?>("mime");
                var name: String? = call.argument<String?>("name");
                if (mime != null && name != null) {
                    createFile(mime, name)
                }
            } else {
                result.notImplemented()
            }
        }
    }


    private fun createFile(mimeType: String, fileName: String) {
        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = mimeType
            putExtra(Intent.EXTRA_TITLE, fileName)
        }
        startActivityForResult(intent, WRITE_REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (data != null) {
            if(data.getData()!=null) {
                val uri: Uri = data.getData()!!
                // Check which request we're responding to
                if (requestCode == WRITE_REQUEST_CODE) {
                    // Make sure the request was successful
                    if (resultCode == Activity.RESULT_OK) {
                        if (data != null && data.getData() != null) {
                            _result?.success(uri.toString())
                        } else {
                            _result?.error("", "No data", null)
                        }
                    } else {
                        _result?.error("", "User cancelled", null)
                    }
                }
            }else{
                _result?.error("", "User cancelled", null)
            }
        }else{
            _result?.error("", "User cancelled", null)
        }
    }
}
