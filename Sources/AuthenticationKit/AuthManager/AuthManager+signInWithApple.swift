//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation
import CryptoKit
import AuthenticationServices




extension AuthManager {
    
    
    public func signInWithApple() { run(signInWithAppleWork) }
    public func signInWithApple() async { await run(signInWithAppleWork) }
    private func signInWithAppleWork() async throws {
        let payload = try await signInWithApplePayload
        let newUser = try await authenticator.signInWithApple(tokenID: payload.token, nonce: payload.nonce)
        try await authenticator.addRemoteUpdatesLisnters(for: newUser)
    }
    private var signInWithApplePayload: SignInWithAppleManager.Payload {
        get async throws {
            let nonce = String.randomNonce32
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = nonce.sha256
            
            let manager = SignInWithAppleManager(nonce: nonce, localizationFile: errorsLocalizationFile)
            
            return try await withCheckedThrowingContinuation { continuation in
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = manager
                authorizationController.performRequests()
                manager.completion = { result in
                    switch result {
                    case .success(let payload): continuation.resume(returning: payload)
                    case .failure(let error): continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    
}
