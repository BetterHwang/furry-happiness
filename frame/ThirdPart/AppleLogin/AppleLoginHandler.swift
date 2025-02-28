//
//  AppleLoginHandler.swift
//  frame
//
//  Created by East on 2025/2/28.
//  Copyright © 2025 yl. All rights reserved.
//

import Foundation
//import ATAuthSDK
import AuthenticationServices

@available(iOS 13.0, *)
class AppleLoginHandler: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    var viewController: UIViewController?
    
    func request(viewController: UIViewController) {
        self.viewController = viewController
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // 请求结束后 删除引用 避免循环引用
    func finish() {
        self.viewController = nil
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController!.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        //苹果登录成功
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email
        // For the purpose of t0 his demo app, store the `userIdentifier` in the keychain.
        let identityTokenStr = String(data: appleIDCredential.identityToken!, encoding: .utf8)
        let authorizationCodeStr = String(bytes: appleIDCredential.authorizationCode!, encoding: .utf8)
        // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
        
        
        let identityToken = appleIDCredential.identityToken
        let authorizationCode = appleIDCredential.authorizationCode
            
        var parameterDic : [String : Any] = [String : Any]()
        parameterDic["identityToken"] = identityTokenStr
        parameterDic["accounttype"] = 1007

  
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.viewController?.present(alertController, animated: true, completion: nil)
    }
    
}
