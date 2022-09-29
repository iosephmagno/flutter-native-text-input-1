package dev.henryleunghk.flutter_native_text_input

import android.app.Activity
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** NativeTextInputPlugin */
class NativeTextInputPlugin: FlutterPlugin/*, ActivityAware */{
  private lateinit var factory: NativeTextInputFactory
//  private lateinit var activity: Activity

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    factory = NativeTextInputFactory(binding/*,activity*/)
    binding.platformViewRegistry.registerViewFactory("flutter_native_text_input", factory)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }

//  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
//    activity = binding.activity;
//  }
//
//  override fun onDetachedFromActivityForConfigChanges() {
//
//  }
//
//  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
//
//  }
//
//  override fun onDetachedFromActivity() {
//
//  }
}
