package com.heart_health_score.heart_health_score
import android.app.Application


// ASSUMPTION: BuildConfig lives in this same package (namespace == applicationId).
// If your namespace differs, import `<namespace>.BuildConfig`.
class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        // Spandan SDK must be initialised in the Application class (per Sunfox doc).
        SpandanBridge.initialize(
            app = this,
            verifierToken = BuildConfig.SPANDAN_VERIFIER_TOKEN,
            masterKey = BuildConfig.SPANDAN_MASTER_KEY,
        )
    }
}