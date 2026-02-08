package com.example.nooruliman

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class ListTileNativeAdFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = NativeAdView(context)

        // Create a horizontal layout container
        val container = android.widget.LinearLayout(context).apply {
            orientation = android.widget.LinearLayout.HORIZONTAL
            setPadding(16, 12, 16, 12)
            layoutParams = android.widget.LinearLayout.LayoutParams(
                android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
            )
        }

        // Ad icon
        val iconView = ImageView(context).apply {
            layoutParams = android.widget.LinearLayout.LayoutParams(48, 48).apply {
                setMargins(0, 0, 12, 0)
            }
            scaleType = ImageView.ScaleType.CENTER_CROP
        }

        // Text container
        val textContainer = android.widget.LinearLayout(context).apply {
            orientation = android.widget.LinearLayout.VERTICAL
            layoutParams = android.widget.LinearLayout.LayoutParams(
                0,
                android.widget.LinearLayout.LayoutParams.WRAP_CONTENT,
                1f
            )
        }

        // Headline
        val headlineView = TextView(context).apply {
            setTextColor(android.graphics.Color.parseColor("#0A5C36"))
            textSize = 14f
            setTypeface(typeface, android.graphics.Typeface.BOLD)
            maxLines = 1
            ellipsize = android.text.TextUtils.TruncateAt.END
        }

        // Body text
        val bodyView = TextView(context).apply {
            setTextColor(android.graphics.Color.parseColor("#6B7F73"))
            textSize = 12f
            maxLines = 2
            ellipsize = android.text.TextUtils.TruncateAt.END
        }

        // "Ad" badge
        val adBadge = TextView(context).apply {
            text = "Ad"
            setTextColor(android.graphics.Color.WHITE)
            textSize = 10f
            setBackgroundColor(android.graphics.Color.parseColor("#0A5C36"))
            setPadding(8, 2, 8, 2)
        }

        textContainer.addView(headlineView)
        textContainer.addView(bodyView)

        container.addView(iconView)
        container.addView(textContainer)
        container.addView(adBadge)

        nativeAdView.addView(container)

        // Set ad assets
        nativeAdView.headlineView = headlineView
        nativeAdView.bodyView = bodyView
        nativeAdView.iconView = iconView

        headlineView.text = nativeAd.headline
        bodyView.text = nativeAd.body

        val icon = nativeAd.icon
        if (icon != null) {
            iconView.setImageDrawable(icon.drawable)
            iconView.visibility = View.VISIBLE
        } else {
            iconView.visibility = View.GONE
        }

        nativeAdView.setNativeAd(nativeAd)
        return nativeAdView
    }
}
