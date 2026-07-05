package com.example.telegram

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.Gravity
import android.view.WindowManager
import android.view.WindowManager.LayoutParams
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.NotificationCompat

/**
 * 透明 Activity
 * 用于在锁屏和其他应用上方显示来电弹窗
 */
class CallOverlayActivity : AppCompatActivity() {
    
    companion object {
        private const val TAG = "CallOverlayActivity"
    }
    
    private var callerName: String = ""
    private var callerId: Int = 0
    private var callType: String = ""
    private var channelName: String = ""
    private var isGroupCall: Boolean = false
    private var groupId: Int? = null
    private var members: String? = null
    private var shouldRecreateNotification = false
    
    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d(TAG, "🎯 [CallOverlayActivity] onCreate 开始")
        try {
            super.onCreate(savedInstanceState)
            Log.d(TAG, "✅ [CallOverlayActivity] super.onCreate 完成")
            
            // 注册当前 Activity 实例到服务
            CallForegroundService.currentCallOverlayActivity = this
            Log.d(TAG, "📝 [CallOverlayActivity] 已注册到服务")
        } catch (e: Exception) {
            Log.e(TAG, "❌ [CallOverlayActivity] super.onCreate 失败: ${e.message}", e)
            return
        }
        
        // 设置为透明窗口，显示在顶部
        window.addFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL)
        window.addFlags(WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH)
        window.addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN)
        window.addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS)
        
        // 设置窗口位置为顶部
        val layoutParams = window.attributes
        layoutParams.gravity = Gravity.TOP or Gravity.CENTER_HORIZONTAL
        layoutParams.y = 50 // 距离顶部的偏移（状态栏高度）
        layoutParams.width = WindowManager.LayoutParams.MATCH_PARENT
        layoutParams.height = WindowManager.LayoutParams.WRAP_CONTENT
        window.attributes = layoutParams
        
        // 显示在锁屏上方
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
        }
        
        // 获取来电信息
        callerName = intent.getStringExtra(CallForegroundService.EXTRA_CALLER_NAME) ?: "未知来电"
        callerId = intent.getIntExtra(CallForegroundService.EXTRA_CALLER_ID, 0)
        callType = intent.getStringExtra(CallForegroundService.EXTRA_CALL_TYPE) ?: "voice"
        channelName = intent.getStringExtra(CallForegroundService.EXTRA_CHANNEL_NAME) ?: ""
        isGroupCall = intent.getBooleanExtra(CallForegroundService.EXTRA_IS_GROUP_CALL, false)
        groupId = if (intent.hasExtra(CallForegroundService.EXTRA_GROUP_ID)) {
            intent.getIntExtra(CallForegroundService.EXTRA_GROUP_ID, 0)
        } else null
        members = intent.getStringExtra(CallForegroundService.EXTRA_MEMBERS)
        
        val callTypeStr = if (isGroupCall) "群组通话" else "单人通话"
        Log.d(TAG, "📋 [CallOverlayActivity] 来电信息: $callerName, ID: $callerId, 类型: $callType ($callTypeStr)")
        if (isGroupCall) {
            Log.d(TAG, "📋 [CallOverlayActivity] 群组ID: $groupId")
            Log.d(TAG, "📋 [CallOverlayActivity] 成员信息: $members")
        }
        
        // 设置布局
        Log.d(TAG, "🎨 [CallOverlayActivity] 设置布局...")
        try {
            setContentView(R.layout.activity_call_overlay)
            Log.d(TAG, "✅ [CallOverlayActivity] 布局设置完成")
        } catch (e: Exception) {
            Log.e(TAG, "❌ [CallOverlayActivity] 布局设置失败: ${e.message}", e)
            return
        }
        
        // 初始化弹窗视图
        Log.d(TAG, "🔧 [CallOverlayActivity] 初始化弹窗视图...")
        try {
            setupCallOverlayView()
            Log.d(TAG, "✅ [CallOverlayActivity] 弹窗视图初始化完成")
        } catch (e: Exception) {
            Log.e(TAG, "❌ [CallOverlayActivity] 弹窗视图初始化失败: ${e.message}", e)
            return
        }
        
        Log.d(TAG, "🎉 [CallOverlayActivity] onCreate 全部完成")
    }
    
    /**
     * 初始化来电弹窗视图
     */
    private fun setupCallOverlayView() {
        val overlayView = findViewById<CallOverlayView>(R.id.call_overlay_view)
        
        // 设置来电信息
        overlayView.setCallInfo(callerName, callType)
        
        // 设置接听按钮监听
        overlayView.setOnAnswerClickListener {
            Log.d(TAG, "✅ 用户点击接听按钮")
            handleAnswer()
        }
        
        // 设置拒绝按钮监听
        overlayView.setOnRejectClickListener {
            Log.d(TAG, "❌ 用户点击拒绝按钮")
            handleReject()
        }
    }
    
    /**
     * 处理接听操作
     */
    private fun handleAnswer() {
        Log.d(TAG, "📱 处理接听：打开主应用")
        
        // 🔴 关键修复：先停止音频播放
        Log.d(TAG, "🔇 通知主应用停止播放音频")
        sendStopAudioBroadcast()
        
        // 关闭前台服务通知
        dismissCallOverlay()
        
        // 标记不需要重新创建通知（正常接听）
        shouldRecreateNotification = false
        
        // 打开主应用
        openMainAppWithCallInfo()
        finish()
    }
    
    /**
     * 关闭来电弹窗和前台服务
     */
    private fun dismissCallOverlay() {
        try {
            val dismissIntent = Intent(this, CallForegroundService::class.java).apply {
                action = CallForegroundService.ACTION_DISMISS_CALL_OVERLAY
            }
            startService(dismissIntent)
            Log.d(TAG, "✅ 已发送关闭弹窗指令")
        } catch (e: Exception) {
            Log.e(TAG, "❌ 关闭弹窗失败: $e")
        }
    }
    
    /**
     * 处理拒绝操作
     */
    private fun handleReject() {
        val callTypeStr = if (isGroupCall) "群组通话" else "单人通话"
        Log.d(TAG, "❌ 处理拒绝: $callTypeStr")
        
        // 🔴 关键：最先设置标志，防止在任何焦点变化时创建通知
        shouldRecreateNotification = false
        Log.d(TAG, "🔴 已设置 shouldRecreateNotification=false，拒绝时不创建通知")
        
        // 🔴 立即关闭前台服务和通知
        Log.d(TAG, "🔴 立即关闭前台服务和通知")
        dismissCallOverlay()
        
        // 🔴 关键修复：通过广播停止音频
        Log.d(TAG, "🔇 发送广播停止播放wait.mp3音频")
        sendStopAudioBroadcast()
        
        // 🔴 发送拒绝消息到服务器（如果是单人通话）
        if (!isGroupCall) {
            Log.d(TAG, "📤 单人通话：需要通知主应用发送拒绝消息")
            // 延迟一小段时间再启动 MainActivity，确保 dismissCallOverlay 先执行
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                notifyCallRejected()
            }, 100)
        } else {
            Log.d(TAG, "📤 群组通话：不需要发送拒绝消息")
        }
        
        // 延迟 finish，确保所有操作都完成
        android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
            finish()
        }, 200)
    }
    
    /**
     * 发送广播停止音频播放（不拉起Activity）
     */
    private fun sendStopAudioBroadcast() {
        val stopAudioIntent = Intent("com.example.telegram.STOP_CALL_AUDIO").apply {
            setPackage(packageName) // 确保只发送给本应用
        }
        sendBroadcast(stopAudioIntent)
        Log.d(TAG, "📡 已发送停止音频广播")
    }
    
    /**
     * 通知主应用发送通话拒绝消息（单人通话）
     */
    private fun notifyCallRejected() {
        val rejectIntent = Intent(this, MainActivity::class.java).apply {
            action = "call_rejected"
            
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            
            // 传递来电信息
            putExtra(CallForegroundService.EXTRA_CALLER_ID, callerId)
            putExtra(CallForegroundService.EXTRA_CALL_TYPE, callType)
        }
        
        Log.d(TAG, "📤 发送拒绝通知到主应用，callerId=$callerId, callType=$callType")
        startActivity(rejectIntent)
    }
    
    /**
     * 打开 Flutter 主应用并传递来电信息
     */
    private fun openMainAppWithCallInfo() {
        val callTypeStr = if (isGroupCall) "群组通话" else "单人通话"
        Log.d(TAG, "📱 准备打开主应用，来电信息: $callerName, ID: $callerId, 类型: $callType ($callTypeStr)")
        if (isGroupCall) {
            Log.d(TAG, "📱 群组ID: $groupId")
        }
        
        val mainIntent = Intent(this, MainActivity::class.java).apply {
            // 设置 Intent 的 action（不是 extra）
            action = "incoming_call"
            
            // 🔴 关键：优化标志，确保直接打开应用并显示在前台
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT) // 如果已存在，直接移到前台
            addFlags(Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT) // 确保 Activity 立即可见
            
            // 🔴 关键修复：标记为已接听，直接进入通话页面，不显示来电弹窗
            // 注意：解锁和显示在锁屏上的逻辑在 MainActivity.onCreate() 中实现
            putExtra("isAnswered", true)
            
            // 传递来电信息
            putExtra(CallForegroundService.EXTRA_CALLER_NAME, callerName)
            putExtra(CallForegroundService.EXTRA_CALLER_ID, callerId)
            putExtra(CallForegroundService.EXTRA_CALL_TYPE, callType)
            putExtra(CallForegroundService.EXTRA_CHANNEL_NAME, channelName)
            putExtra(CallForegroundService.EXTRA_IS_GROUP_CALL, isGroupCall)
            if (isGroupCall && groupId != null) {
                putExtra(CallForegroundService.EXTRA_GROUP_ID, groupId)
                if (members != null) {
                    putExtra(CallForegroundService.EXTRA_MEMBERS, members)
                }
            }
        }
        
        Log.d(TAG, "🔑 已标记为已接听 (isAnswered=true)，将直接进入通话页面")
        
        Log.d(TAG, "📤 启动主应用 Intent，action=${mainIntent.action}")
        startActivity(mainIntent)
        Log.d(TAG, "✅ 主应用已启动")
    }
    
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        Log.d(TAG, "🔍 [CallOverlayActivity] 窗口焦点变化: hasFocus=$hasFocus")
        
        if (!hasFocus) {
            // 🔴 关键修复：失去焦点时标记需要重新创建通知
            shouldRecreateNotification = true
        }
    }
    
    /**
     * 创建来电通知（当Activity进入后台时）
     */
    private fun createCallNotification() {
        try {
            Log.d(TAG, "📢 [CallOverlayActivity] 创建来电通知...")
            
            // 创建点击通知时打开Activity的Intent
            val notificationIntent = Intent(this, CallOverlayActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
                
                // 传递来电信息
                putExtra(CallForegroundService.EXTRA_CALLER_NAME, callerName)
                putExtra(CallForegroundService.EXTRA_CALLER_ID, callerId)
                putExtra(CallForegroundService.EXTRA_CALL_TYPE, callType)
                putExtra(CallForegroundService.EXTRA_CHANNEL_NAME, channelName)
                putExtra(CallForegroundService.EXTRA_IS_GROUP_CALL, isGroupCall)
                if (isGroupCall && groupId != null) {
                    putExtra(CallForegroundService.EXTRA_GROUP_ID, groupId)
                    if (members != null) {
                        putExtra(CallForegroundService.EXTRA_MEMBERS, members)
                    }
                }
            }
            
            val pendingIntent = PendingIntent.getActivity(
                this,
                0,
                notificationIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            
            // 根据通话类型和是否群组通话，构建不同的通知标题和内容
            val callTypeText = when (callType) {
                "voice" -> "语音通话"
                "video" -> "视频通话"
                else -> "通话"
            }
            
            val title = if (isGroupCall) {
                "群组${callTypeText}: $callerName"
            } else {
                "${callTypeText}来电: $callerName"
            }
            
            val content = if (isGroupCall) {
                "点击返回群组通话界面"
            } else {
                "点击返回通话界面"
            }
            
            Log.d(TAG, "📢 [CallOverlayActivity] 通知内容 - 标题: $title, 内容: $content")
            
            // 创建通知
            val notification = NotificationCompat.Builder(this, "call_channel")
                .setContentTitle(title)
                .setContentText(content)
                .setSmallIcon(android.R.drawable.ic_menu_call)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setCategory(NotificationCompat.CATEGORY_CALL)
                .setContentIntent(pendingIntent)
                .setAutoCancel(false) // 🔴 关键：不自动取消，这样通知会一直保留
                .setOngoing(true) // 🔴 持续通知，不可滑动删除
                .setDefaults(NotificationCompat.DEFAULT_ALL)
                .build()
            
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.notify(CallForegroundService.NOTIFICATION_ID + 1, notification)
            
            Log.d(TAG, "✅ [CallOverlayActivity] 来电通知已创建")
        } catch (e: Exception) {
            Log.e(TAG, "❌ [CallOverlayActivity] 创建通知失败: ${e.message}", e)
        }
    }
    
    /**
     * 取消来电通知（当Activity回到前台时）
     */
    private fun cancelCallNotification() {
        try {
            Log.d(TAG, "🔕 [CallOverlayActivity] 取消来电通知...")
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.cancel(CallForegroundService.NOTIFICATION_ID + 1)
            Log.d(TAG, "✅ [CallOverlayActivity] 来电通知已取消")
        } catch (e: Exception) {
            Log.e(TAG, "❌ [CallOverlayActivity] 取消通知失败: ${e.message}", e)
        }
    }
    
    override fun onBackPressed() {
        // 禁止返回键关闭
        // super.onBackPressed()
    }
    
    override fun onDestroy() {
        super.onDestroy()
        
        // 🔴 关键修复：如果Activity因为失去焦点而被销毁，重新创建通知
        if (shouldRecreateNotification) {
            Log.d(TAG, "📢 [CallOverlayActivity] Activity被销毁，重新创建通知...")
            createCallNotification()
        } else {
            // 正常销毁（比如接听/拒绝），取消通知
            Log.d(TAG, "🔕 [CallOverlayActivity] Activity正常销毁，取消通知...")
            cancelCallNotification()
        }
        
        // 注销当前 Activity 实例
        if (CallForegroundService.currentCallOverlayActivity == this) {
            CallForegroundService.currentCallOverlayActivity = null
            Log.d(TAG, "📝 [CallOverlayActivity] 已从服务注销")
        }
        
        Log.d(TAG, "🗑️ [CallOverlayActivity] onDestroy 完成")
    }
}
