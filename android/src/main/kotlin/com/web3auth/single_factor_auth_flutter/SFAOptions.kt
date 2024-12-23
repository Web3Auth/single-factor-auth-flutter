package com.web3auth.single_factor_auth_flutter

import android.net.Uri

data class SFAOptions(
    val network: String,
    var clientId: String,
    var sessionTime: Int = 86400,
    var redirectUrl: Uri? = null
)