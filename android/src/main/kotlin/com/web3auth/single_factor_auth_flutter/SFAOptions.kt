package com.web3auth.single_factor_auth_flutter

import androidx.annotation.Keep
import java.io.Serializable

@Keep
data class SFAOptions(
    @Keep val network: String,
    @Keep var clientId: String,
    @Keep var sessionTime: Int = 86400,
    @Keep var redirectUrl: String? = null
): Serializable