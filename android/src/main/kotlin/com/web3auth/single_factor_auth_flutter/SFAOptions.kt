package com.web3auth.single_factor_auth_flutter

data class SFAOptions(val network: String, var clientid: String, var sessionTime: Int = 86400)