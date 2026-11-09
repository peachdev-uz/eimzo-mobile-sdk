package uz.eimzo.example

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.widget.ArrayAdapter
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isVisible
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import org.json.JSONArray
import org.json.JSONObject
import uz.eimzo.example.databinding.ActivityMainBinding
import uz.eimzo.sdk.EImzoConfig
import uz.eimzo.sdk.EImzoEnvironment
import uz.eimzo.sdk.EImzoSDK
import uz.eimzo.sdk.EImzoSignLink
import uz.eimzo.sdk.fullui.EImzoActivity
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Minimal demo of the E-IMZO Mobile SDK.
 *
 * Three integration patterns are shown:
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
 * 3. **Keys API** («Kalitlar API») — [EImzoSDK.getKeys] lists the keys the
 *    user has added in the SDK, as JSON, and [EImzoSDK.sign] signs the same
 *    request with the key picked here, in the SDK's own window. Only for an
 *    integrator YT has given the permission (info@yt.uz, after a contract);
 *    without it both answer `api_not_allowed`, and the example shows that.
 *
 * Everything goes through [EImzoSDK.checkLicenseAndInit] first: it hands the
 * SDK this app's [EImzoConfig] and checks the app with the YT gateway. The
 * app takes no `eimzo://` links from outside — that scheme is the E-IMZO
 * app's, so the manifest has no intent-filter for it.
 *
 * That's the entire integration. The SDK owns all UI — blocked-app screen,
 * key management, NFC wait animations, QR scanner, USB token detection —
 * you just open the activity.
 */
class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    /** The Keys API's answers, kept across a rotation — see [KeysApiViewModel]. */
    private lateinit var keysApi: KeysApiViewModel

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
        keysApi = ViewModelProvider(this)[KeysApiViewModel::class.java]

        // 1. Open the full E-IMZO UI (Home → Keys → AddKey → Sign).
        binding.btnOpenSdk.setOnClickListener {
            launchEimzo(link = null)
        }

        // 2. Sign a document — the sign request is made here, in the app.
        binding.btnSignDocument.setOnClickListener {
            launchEimzo(EImzoSignLink.create(DEMO_SITE_ID, DEMO_DOCUMENT_ID, DEMO_HASH))
        }

        // 3. Keys API — list the user's keys, sign 2's request with one of them.
        binding.btnListKeys.setOnClickListener { listKeys() }
        binding.btnSignWithKey.setOnClickListener { signWithPickedKey() }
        keysApi.keys.observe(this) { keys ->
            binding.spinnerKeys.adapter =
                ArrayAdapter(this, android.R.layout.simple_spinner_dropdown_item, keys.map(::label))
            binding.spinnerKeys.isVisible = keys.isNotEmpty()
            binding.btnSignWithKey.isEnabled = keys.isNotEmpty()
        }
        keysApi.json.observe(this) { json -> binding.txtKeysJson.text = json }
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

    /**
     * «Kalitlar ro'yxati»: the keys the user has added in [EImzoActivity].
     * The Keys API answers `not_initialized` until `checkLicenseAndInit` has
     * said `allowed` in this process.
     */
    private fun listKeys() {
        EImzoSDK.checkLicenseAndInit(this, eimzoConfig) { allowed ->
            if (!allowed) return@checkLicenseAndInit
            EImzoSDK.getKeys { json ->
                // {"status":"ok","keys":[{"id","pinfl","name","validFrom","validTo"}]},
                // or {"status":"error","code":…,"message":…} and no keys.
                val reply = JSONObject(json)
                val keys = if (reply.getString("status") == "ok") reply.getJSONArray("keys") else JSONArray()
                keysApi.keys.value = List(keys.length(), keys::getJSONObject)
                keysApi.json.value = json
            }
        }
    }

    /**
     * «Tanlangan kalit bilan imzolash»: button 2's sign request, signed with
     * the key picked in the list, in the SDK's window over this activity.
     * The JSON says how it ended — signed, cancelled or an error. The signed
     * document goes from E-IMZO to the site's backend, not to the app.
     */
    private fun signWithPickedKey() {
        val key = keysApi.keys.value?.getOrNull(binding.spinnerKeys.selectedItemPosition) ?: return
        val link = EImzoSignLink.create(DEMO_SITE_ID, DEMO_DOCUMENT_ID, DEMO_HASH)
        EImzoSDK.sign(this, key.getString("id"), link) { json -> keysApi.json.value = json }
    }

    /** A key in the list: its owner and `validTo` — expired keys are listed too. */
    private fun label(key: JSONObject): String {
        val name = key.getString("name")
        if (key.isNull("validTo")) return name
        val validTo = key.getString("validTo")
        val today = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
        return if (validTo < today) "$name · $validTo (muddati o'tgan)" else "$name · $validTo"
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

/**
 * The Keys API's last answers, kept across a rotation. The SDK calls back
 * once — also when the screen turned while its sign window was open and the
 * activity that asked is gone. So the callbacks write here, not to a view,
 * and the activity on screen shows what is here.
 */
class KeysApiViewModel : ViewModel() {

    /** The keys from the last «Kalitlar ro'yxati», the default key first. */
    val keys = MutableLiveData<List<JSONObject>>(emptyList())

    /** The last JSON from `getKeys` or `sign`, as the SDK gave it. */
    val json = MutableLiveData<String>()
}
