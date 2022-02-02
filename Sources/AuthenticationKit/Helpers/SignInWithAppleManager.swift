//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation
import AuthenticationServices




class SignInWithAppleManager: NSObject, ASAuthorizationControllerDelegate {
    
    
    struct Payload {
        let token: String
        let nonce: String
    }
    
    let nonce: String?
    let localizationFile: String?
    var completion: ((Result<Payload?,Error>) -> ())?
    
    init(nonce: String?, localizationFile: String?) {
        self.nonce = nonce
        self.localizationFile = localizationFile
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = nonce else {
                completion?(.failure(NonceMissing(localizationFile: localizationFile)))
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                completion?(.failure(IdentityTokenMissing(localizationFile: localizationFile)))
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                completion?(.failure(TokenSerializationFailure(token: appleIDToken, localizationFile: localizationFile)))
                return
            }
            completion?(.success(Payload(token: idTokenString, nonce: nonce)))
        } else {
            completion?(.failure(AutherizationCredentialsMissing(localizationFile: localizationFile)))
        }
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let error = error as? ASAuthorizationError, error.errorCode == 1001 else { completion?(.failure(error)) ; return }
        // Authentication was canceled by the user
        completion?(.success(nil))
    }
    
    
}
