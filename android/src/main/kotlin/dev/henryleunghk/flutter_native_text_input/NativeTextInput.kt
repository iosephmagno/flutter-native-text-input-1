package dev.henryleunghk.flutter_native_text_input

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.os.Build
import android.text.Editable
import android.text.InputType
import android.text.TextWatcher
import android.util.Log
import android.util.TypedValue
import android.view.GestureDetector
import android.view.GestureDetector.SimpleOnGestureListener
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import androidx.annotation.NonNull
import com.google.android.material.textfield.TextInputEditText
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


val TAG: String = "NativeTextInput"

internal class NativeTextInput(
    context: Context,
    id: Int,
    creationParams: Map<String?, Any?>,
    channel: MethodChannel,
//    activity: Activity,
) : PlatformView, MethodChannel.MethodCallHandler {
    private val context: Context
    private val scaledDensity: Float
    private val editText: TextInputEditText

    override fun getView(): View {
        return editText
    }

    override fun dispose() {}

    init {
        this.context = context
        scaledDensity = context.resources.displayMetrics.scaledDensity


        editText = EditText(context)
        //editText.setBackgroundResource(android.R.color.transparent)

        editText.setBackgroundResource(R.drawable.edit_text_background)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            editText.setTextCursorDrawable(R.drawable.edit_text_cursor)
        }

        if (creationParams["fontColor"] != null) {
            val rgbMap = creationParams["fontColor"] as Map<String, Float>
            val color = Color.argb(
                rgbMap["alpha"] as Int,
                rgbMap["red"] as Int,
                rgbMap["green"] as Int,
                rgbMap["blue"] as Int
            )
            editText.setTextColor(color)
        }

        if (creationParams["fontSize"] != null) {
            val fontSize = creationParams["fontSize"] as Double
            Log.d(TAG, "fontSize:$fontSize")
            editText.setTextSize(TypedValue.COMPLEX_UNIT_SP, fontSize.toFloat())
            editText.textSize = fontSize.toFloat()
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
//                editText.lineHeight = fontSize.toInt()
//            }
        }

        val gestureDetector = GestureDetector(context, object : SimpleOnGestureListener() {
            override fun onSingleTapUp(e: MotionEvent?): Boolean {
                if (!editText.hasFocus()) {
                    editText.requestFocus()
                }
                channel.invokeMethod("singleTapRecognized", null)
                Log.e(TAG, "onSingleTapUp: ")
                return super.onSingleTapUp(e)
            }
        })

        editText.setOnTouchListener { v, event -> gestureDetector.onTouchEvent(event) }

        if (creationParams["fontWeight"] != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            when (creationParams["fontWeight"] as String) {
                "FontWeight.w100" -> {
                    editText.typeface = Typeface.create(editText.typeface, 100, false)
                }
                "FontWeight.w200" -> {
                    editText.typeface = Typeface.create(editText.typeface, 200, false)
                }
                "FontWeight.w300" -> {
                    editText.typeface = Typeface.create(editText.typeface, 300, false)
                }
                "FontWeight.w400" -> {
                    editText.typeface = Typeface.create(editText.typeface, 400, false)
                }
                "FontWeight.w500" -> {
                    editText.typeface = Typeface.create(editText.typeface, 500, false)
                }
                "FontWeight.w600" -> {
                    editText.typeface = Typeface.create(editText.typeface, 600, false)
                }
                "FontWeight.w700" -> {
                    editText.typeface = Typeface.create(editText.typeface, 700, false)
                }
                "FontWeight.w800" -> {
                    editText.typeface = Typeface.create(editText.typeface, 800, false)
                }
                "FontWeight.w900" -> {
                    editText.typeface = Typeface.create(editText.typeface, 900, false)
                }
            }
        }

        val minLines = creationParams["minLines"] as Int
        editText.minLines = minLines
        editText.setLines(minLines)

        val maxLines = creationParams["maxLines"] as Int
        if (maxLines > minLines) {
            editText.maxLines = maxLines
        } else {
            editText.maxLines = minLines
        }

        val minHeightPadding = creationParams["minHeightPadding"] as Double
        editText.setPadding(
            0, minHeightPadding.toInt() / 2, 0, minHeightPadding.toInt() / 2
        )

        editText.hint = creationParams["placeholder"] as String

        if (creationParams["placeholderFontColor"] != null) {
            val rgbMap = creationParams["placeholderFontColor"] as Map<String, Float>
            val color = Color.argb(
                rgbMap["alpha"] as Int,
                rgbMap["red"] as Int,
                rgbMap["green"] as Int,
                rgbMap["blue"] as Int
            )
            editText.setHintTextColor(color)
        }

        if (creationParams["returnKeyType"] != null) {
            when (creationParams["returnKeyType"] as String) {
                "ReturnKeyType.go" -> {
                    editText.imeOptions = EditorInfo.IME_ACTION_GO
                }
                "ReturnKeyType.next" -> {
                    editText.imeOptions = EditorInfo.IME_ACTION_NEXT
                }
                "ReturnKeyType.search" -> {
                    editText.imeOptions = EditorInfo.IME_ACTION_SEARCH
                }
                "ReturnKeyType.send" -> {
                    editText.imeOptions = EditorInfo.IME_ACTION_SEND
                }
                "ReturnKeyType.done" -> {
                    editText.imeOptions = EditorInfo.IME_ACTION_DONE
                }
            }
        }

        if (creationParams["text"] != null) {
            val text = creationParams["text"] as String
            editText.setText(text)
        }

        if (creationParams["textAlign"] != null) {
            when (creationParams["textAlign"] as String) {
                "TextAlign.left" -> {
                    editText.gravity = Gravity.LEFT
                }
                "TextAlign.right" -> {
                    editText.gravity = Gravity.RIGHT
                }
                "TextAlign.center" -> {
                    editText.gravity = Gravity.CENTER
                }
                "TextAlign.justify" -> {
                    editText.gravity = Gravity.FILL
                }
                "TextAlign.start" -> {
                    editText.gravity = Gravity.START
                }
                "TextAlign.end" -> {
                    editText.gravity = Gravity.END
                }
            }
        }

        if (creationParams.get("textCapitalization") != null) {
            when (creationParams["textCapitalization"] as String) {
                "TextCapitalization.none" -> {
                    editText.inputType = InputType.TYPE_CLASS_TEXT
                }
                "TextCapitalization.characters" -> {
                    editText.inputType =
                        InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS
                }
                "TextCapitalization.sentences" -> {
                    editText.inputType =
                        InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_FLAG_CAP_SENTENCES
                }
                "TextCapitalization.words" -> {
                    editText.inputType =
                        InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_FLAG_CAP_WORDS
                }
            }
        }

        if (creationParams["keyboardType"] != null) {
            when (creationParams["keyboardType"] as String) {
                "KeyboardType.numbersAndPunctuation", "KeyboardType.numberPad", "KeyboardType.asciiCapableNumberPad" -> {
                    editText.inputType = InputType.TYPE_CLASS_NUMBER
                }
                "KeyboardType.phonePad" -> {
                    editText.inputType = InputType.TYPE_CLASS_PHONE
                }
                "KeyboardType.decimalPad" -> {
                    editText.inputType =
                        InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                }
                "KeyboardType.url", "KeyboardType.webSearch" -> {
                    editText.inputType = editText.inputType or InputType.TYPE_TEXT_VARIATION_URI
                }
                "KeyboardType.emailAddress" -> {
                    editText.inputType =
                        editText.inputType or InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS
                }
            }
        } else if (creationParams["textContentType"] != null) {
            when (creationParams["textContentType"] as String) {
                "TextContentType.username", "TextContentType.givenName", "TextContentType.middleName", "TextContentType.familyName", "TextContentType.nickname" -> {
                    editText.inputType =
                        editText.inputType or InputType.TYPE_TEXT_VARIATION_PERSON_NAME
                }
                "TextContentType.password", "TextContentType.newPassword" -> {
                    editText.inputType =
                        editText.inputType or InputType.TYPE_TEXT_VARIATION_PASSWORD
                }
                "TextContentType.fullStreetAddress", "TextContentType.streetAddressLine1", "TextContentType.streetAddressLine2", "TextContentType.addressCity", "TextContentType.addressState", "TextContentType.addressCityAndState" -> {
                    editText.inputType =
                        editText.inputType or InputType.TYPE_TEXT_VARIATION_POSTAL_ADDRESS
                }
                "TextContentType.telephoneNumber" -> {
                    editText.inputType = InputType.TYPE_CLASS_PHONE
                }
                "TextContentType.emailAddress" -> {
                    editText.inputType =
                        editText.inputType or InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS
                }
                "TextContentType.url" -> {
                    editText.inputType = editText.inputType or InputType.TYPE_TEXT_VARIATION_URI
                }
            }
        }

        val width = creationParams["width"] as Double
        editText.maxWidth = width.toInt()

        if (minLines > 1 || maxLines > 1) {
            editText.inputType = editText.inputType or InputType.TYPE_TEXT_FLAG_MULTI_LINE
            editText.setHorizontallyScrolling(false)
        }
        editText.setOnFocusChangeListener { v, hasFocus ->
            Log.d(TAG, "hasFocus:$hasFocus")
            if (hasFocus) {
                channel.invokeMethod("inputStarted", null)
            } else {
                channel.invokeMethod("inputFinished", mapOf("text" to editText.text.toString()))
            }
        }

        editText.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(
                text: CharSequence?, start: Int, before: Int, count: Int
            ) {

            }

            override fun onTextChanged(text: CharSequence?, start: Int, count: Int, after: Int) {
                Log.d(TAG, "doOnTextChanged:text:" + text.toString())
                Log.d(TAG, "doOnTextChanged:lineCount:" + editText.lineCount);
                Log.e(TAG, "onTextChanged: $start:$count")

                channel.invokeMethod("inputValueChanged", mapOf("text" to text.toString()))
            }

            override fun afterTextChanged(e: Editable?) {

            }
        })

        channel.setMethodCallHandler(this)
    }

    private fun EditText.placeCursorToEnd() {
        this.setSelection(this.text.length)
    }

    private fun showKeyboard() {
        val inputMethodManager: InputMethodManager =
            context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        inputMethodManager.showSoftInput(editText, 0)
    }

    private fun hideKeyboard() {
        val inputMethodManager =
            context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        inputMethodManager.hideSoftInputFromWindow(editText.windowToken, 0)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "getContentHeight" -> {
                var contentHeight = editText.lineHeight / scaledDensity * editText.lineCount
                Log.d(TAG, "getContentHeight:$contentHeight")
                result.success(contentHeight.toDouble() + 10)
            }
            "getLineHeight" -> {
                val lineHeight = editText.textSize / scaledDensity
                Log.d(TAG, "getLineHeight:$lineHeight")
                result.success(lineHeight.toDouble())
            }
            "focus" -> {
                editText.requestFocus()
                showKeyboard()
            }
            "unfocus" -> {
                editText.clearFocus()
                hideKeyboard()
            }
            "setText" -> {
                val text = call.argument<String>("text")
                editText.setText(text)
            }
        }
    }
}