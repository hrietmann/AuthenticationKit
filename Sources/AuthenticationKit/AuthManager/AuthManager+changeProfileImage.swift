//
//  File.swift
//  
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation



extension AuthManager {
    
    
    // MARK: - Change Profile Image -
    public func changeProfileImage() { run(changeProfileImageWork) }
    public func changeProfileImage() async { await run(changeProfileImageWork) }
    private func changeProfileImageWork() async throws {
        guard let user = user else { throw UserNotSignedIn(localizationFile: errorsLocalizationFile) }
#if os(iOS) || os(tvOS)
        let image = profileImage?.resized(to: .init(width: 300, height: 300))
        try await authenticator.change(profile: image, of: user)
#endif
#if os(macOS)
        try await authenticator.change(profile: profileImage, of: user)
#endif
    }
    
    
}
