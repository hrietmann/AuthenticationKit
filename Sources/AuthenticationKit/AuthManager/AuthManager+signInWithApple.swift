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
            try await withCheckedThrowingContinuation { continuation in
                let nonce = String.randomNonce32
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                request.nonce = nonce.sha256
                
                let manager = SignInWithAppleManager(nonce: nonce, localizationFile: errorsLocalizationFile, completion: continuation.resume(with:))
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = manager
//                authorizationController.presentationContextProvider = manager
                authorizationController.performRequests()
            }
        }
    }
    
    
}
