package com.example.tube_filter

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

class HomeWidgetReceiver : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.home_widget)

            // Get data from SharedPreferences
            val videosJson = widgetData.getString("videos", "[]") ?: "[]"
            val count = widgetData.getInt("count", 0)

            // Parse videos JSON
            try {
                val videosArray = JSONArray(videosJson)
                
                // Update video titles
                if (videosArray.length() > 0) {
                    views.setTextViewText(R.id.video_title_1, "• " + videosArray.getJSONObject(0).getString("title"))
                }
                if (videosArray.length() > 1) {
                    views.setTextViewText(R.id.video_title_2, "• " + videosArray.getJSONObject(1).getString("title"))
                }
                if (videosArray.length() > 2) {
                    views.setTextViewText(R.id.video_title_3, "• " + videosArray.getJSONObject(2).getString("title"))
                }
            } catch (e: Exception) {
                views.setTextViewText(R.id.video_title_1, "• Open app to sync")
            }

            // Update count
            views.setTextViewText(R.id.widget_count, "$count videos")

            // Update the widget
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
