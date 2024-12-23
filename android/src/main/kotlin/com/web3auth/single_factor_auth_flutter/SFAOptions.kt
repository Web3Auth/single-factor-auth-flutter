package com.web3auth.single_factor_auth_flutter

data class SFAOptions(
    val network: String,
    var clientId: String,
    var sessionTime: Int = 86400,
    var redirectUrl: String? = null
)