//
//  ViewController.swift
//  SignInWithApple
//
//  Created by JanSzala on 28/08/2019.
//  Copyright © 2019 JanSzala. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    @IBOutlet weak var containerStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSignInWithAppleButton()
    }
    
    private func setupSignInWithAppleButton() {
        let signInWithAppleButton = ASAuthorizationAppleIDButton()
        signInWithAppleButton.addTarget(self, action: #selector(handleSignInWithApple), for: .touchUpInside)
        containerStackView.addArrangedSubview(signInWithAppleButton)
    }
    
    @objc
    private func handleSignInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("Encountered an authorization error")
            return
        }
        
        print("User correctly authenticated")
        print("User: \(credential.fullName?.givenName ?? "") \(credential.fullName?.familyName ?? ""), email: \(credential.email ?? "")")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alert = UIAlertController(title: "Authorization Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
