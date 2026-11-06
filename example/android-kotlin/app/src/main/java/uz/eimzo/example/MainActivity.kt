package uz.eimzo.example

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import uz.eimzo.example.databinding.ActivityMainBinding
import uz.eimzo.sdk.EImzoConfig
import uz.eimzo.sdk.EImzoEnvironment
import uz.eimzo.sdk.EImzoSDK
import uz.eimzo.sdk.EImzoSignLink
import uz.eimzo.sdk.fullui.EImzoActivity

/**
 * Minimal demo of the E-IMZO Mobile SDK.
 *
 * Two integration patterns are shown:
 *
 * 1. **Open the full UI** — launch [EImzoActivity] with no `data`.
 *    The user lands on the Home screen, can add keys (PFX / QR / ID card /
 *    USB token / BAIK token), manage saved keys, and sign by scanning a QR.
 *
 * 2. **Sign a document** — the app gets the document's `siteId`,
 *    `documentId` and `hash` from its own backend, makes the sign request
 *    with [EImzoSignLink.create] and passes it as `data`. The SDK shows the
 *    request, signs once the user taps IMZOLASH, and returns to the app.
 *
 * Both go through [EImzoSDK.checkLicenseAndInit] first: it hands the SDK
 * this app's [EImzoConfig] and checks the app with the YT gateway. The app
 * takes no `eimzo://` links from outside — that scheme is the E-IMZO app's,
 * so the manifest has no intent-filter for it.
 *
 * That's the entire integration. The SDK owns all UI — blocked-app screen,
 * key management, NFC wait animations, QR scanner, USB token detection —
 * you just open the activity.
 */
class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    /**
     * Debug builds sign in YT's test environment (test.e-imzo.uz, test keys
     * only) and log the SDK's steps to logcat; release builds sign in E-IMZO
     * itself. The app must be registered in the environment it uses.
     */
    private val eimzoConfig = EImzoConfig(
        environment = if (BuildConfig.DEBUG) EImzoEnvironment.DEV else EImzoEnvironment.PROD,
        debugLogging = BuildConfig.DEBUG,
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // 1. Open the full E-IMZO UI (Home → Keys → AddKey → Sign).
        binding.btnOpenSdk.setOnClickListener {
            launchEimzo(link = null)
        }

        // 2. Sign a document — the sign request is made here, in the app.
        binding.btnSignDocument.setOnClickListener {
            launchEimzo(EImzoSignLink.create(DEMO_SITE_ID, DEMO_DOCUMENT_ID, DEMO_HASH))
        }
    }

    /**
     * Checks the app with the gateway, then opens the SDK — with [link] as
     * its sign request, or on Home when there is none. A refused app gets the
     * SDK's blocked screen over this activity, and `allowed` is false.
     */
    private fun launchEimzo(link: String?) {
        EImzoSDK.checkLicenseAndInit(this, eimzoConfig) { allowed ->
            if (!allowed) return@checkLicenseAndInit
            startActivity(Intent(this, EImzoActivity::class.java).apply {
                if (link != null) data = Uri.parse(link)
            })
        }
    }

    private companion object {
        /**
         * A document from a QA signing session. In your app the site's id,
         * the document's id and the hash come from your backend;
         * [EImzoSignLink.create] checks their form (4; 8, 10, 12, 14 or 16;
         * 64 hex characters) and throws IllegalArgumentException otherwise.
         */
        const val DEMO_SITE_ID = "1a47"
        const val DEMO_DOCUMENT_ID = "59282737"
        const val DEMO_HASH = "518b091cc3878831103872e422ec71d2e6ee501e255dce3290af02042edfcd69"
    }
}
