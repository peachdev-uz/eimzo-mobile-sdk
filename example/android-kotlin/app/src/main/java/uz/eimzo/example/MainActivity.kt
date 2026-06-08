package uz.eimzo.example

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import uz.eimzo.example.databinding.ActivityMainBinding
import uz.eimzo.sdk.fullui.EImzoActivity

/**
 * Minimal demo of the E-IMZO Mobile SDK.
 *
 * Two integration patterns are shown:
 *
 * 1. **Open the full UI** — launch [EImzoActivity] with no extras.
 *    The user lands on the Home screen, can add keys (PFX / QR / NFC),
 *    manage saved keys, and sign documents.
 *
 * 2. **Deep-link into the sign flow** — pass an `eimzo://sign?qc=…` URI
 *    as `data`. The SDK jumps straight into the password prompt,
 *    signs, and returns control to your app.
 *
 * That's the entire integration. The SDK owns all UI — license check,
 * blocked-app screen, key management, NFC wait animations, QR scanner,
 * USB token detection — you just open the activity.
 */
class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // 1. Open the full E-IMZO UI (Home → Keys → AddKey → Sign).
        binding.btnOpenSdk.setOnClickListener {
            startActivity(Intent(this, EImzoActivity::class.java))
        }

        // 2. Open with a deep link — jumps straight into the sign flow.
        binding.btnSignWithDeepLink.setOnClickListener {
            val intent = Intent(this, EImzoActivity::class.java).apply {
                data = Uri.parse(DEMO_DEEP_LINK)
            }
            startActivity(intent)
        }

        // 3. If your app itself was opened via `eimzo://sign?qc=…` (e.g.
        //    from a browser), forward the URI into the SDK.
        intent?.data?.let { uri ->
            if (uri.scheme == "eimzo" && uri.host == "sign") {
                startActivity(Intent(this, EImzoActivity::class.java).apply {
                    data = uri
                })
            }
        }
    }

    private companion object {
        /**
         * Sample QR code (`qc` query parameter) from a real signing session.
         * Replace with whatever the issuing portal hands your user.
         */
        const val DEMO_DEEP_LINK =
            "eimzo://sign?qc=1a4759282737518b091cc3878831103872e422ec71d2e6ee501e255dce3290af02042edfcd6989e4017b"
    }
}
