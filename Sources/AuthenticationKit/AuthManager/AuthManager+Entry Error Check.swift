//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation




extension AuthManager {
    
    
    // MARK: - Entry error checks -
    public var usernameError: Error? {
        guard !usernameEntry.isEmpty
        else { return UsernameMissing(localizationFile: errorsLocalizationFile) }
        
        guard usernameEntry.isValidUsername
        else { return InvalidUsernameFormat(localizationFile: errorsLocalizationFile) }
        return nil
    }
    public var emailError: Error? {
        guard !emailEntry.isEmpty
        else { return EmailMissing(localizationFile: errorsLocalizationFile) }
        
        guard emailEntry.isValidEmail
        else { return EmailMissing(localizationFile: errorsLocalizationFile) }
        return nil
    }
    public var passwordError: Error? {
        guard !passwordEntry.isEmpty
        else { return PasswordMissing(localizationFile: errorsLocalizationFile) }
        
        let constraints = Authenticator.passwordConstraints
        guard passwordEntry.isValidPassword(with: constraints)
        else { return InvalidPasswordFormat(localizationFile: errorsLocalizationFile, constaints: constraints) }
        return nil
    }
    public var password2Error: Error? {
        guard !passwordEntry2.isEmpty
        else { return PasswordMissing(localizationFile: errorsLocalizationFile) }
        
        let constraints = Authenticator.passwordConstraints
        guard passwordEntry2.isValidPassword(with: constraints)
        else { return InvalidPasswordFormat(localizationFile: errorsLocalizationFile, constaints: constraints) }
        
        guard passwordEntry == passwordEntry2
        else { return PasswordMismatch(localizationFile: errorsLocalizationFile) }
        return nil
    }
    
    
}
