package com.web3auth.single_factor_auth_flutter

data class Web3AuthOptions(
    val verifier: String,
    val verifierId: String,
    val idToken: String,
    val aggregateVerifier: String? = null
)


