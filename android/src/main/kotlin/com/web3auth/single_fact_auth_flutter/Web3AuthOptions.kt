package com.web3auth.single_fact_auth_flutter

data class Web3AuthOptions(
    val verifier: String,
    val email: String,
    val idToken: String,
    val aggregateVerifier: String? = null
)


