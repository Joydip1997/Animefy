package com.androdude.animefy

import android.app.WallpaperManager
import android.content.Context
import android.graphics.BitmapFactory
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

import java.net.URI


class MainActivity: FlutterActivity() {
    private val CHANNEL = "set_wallpaper"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "getWallPaper") {
                val filepath = call.argument<String>("url")

                settingWallpapaer(this,filepath!!)


            } else {
                result.notImplemented()
            }
        }
    }





    fun settingWallpapaer( context : Context,filePath : String) : String
    {
        val metrics = windowManager.defaultDisplay
        val height = metrics.height
        val width = metrics.width
        val path = filePath
        val file = File(URI(filePath))
        try {
            val myWallpaperManager = WallpaperManager.getInstance(context)
            val mybitmap = BitmapFactory.decodeFile(file.toString())

            myWallpaperManager.setBitmap(mybitmap)
            return "Set"

        } catch (e: Exception) {
            // TODO Auto-generated catch block
            e.printStackTrace()
            return "Error"
        }
    }

}
