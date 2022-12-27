//
//  AuthViewController.swift
//  
//
//  Created by Александр Казак-Казакевич on 26.12.2022.
//

import UIKit

/// View of the Detail Point module.
final class AuthViewController: UIViewController {

    // MARK: VIPER
    private let presenter: AuthViewToPresenterProtocol
    
    // MARK: Visual Components
    private lazy var emailField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Email"
        field.spellCheckingType = .no
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textContentType = .emailAddress
        field.keyboardType = .emailAddress
        field.delegate = self
        
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Password"
        field.spellCheckingType = .no
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        field.textContentType = .password
        field.delegate = self
        
        return field
    }()
    
    private lazy var authButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(authTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.alpha = 0
        
        return indicator
    }()
    
    var alert: AlertView?
    
    // MARK: Public Properties
    let hapticsGenerator: HapticsGeneratorProtocol
    
    // MARK: Initializers
    init(presenter: AuthViewToPresenterProtocol, hapticsGenerator: HapticsGeneratorProtocol) {
        self.presenter = presenter
        self.hapticsGenerator = hapticsGenerator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        
        addAndLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissTapped))
        navigationItem.rightBarButtonItem = dismissButton
        
        emailField.becomeFirstResponder()
    }
    
    // MARK: Private Methods
    private func addAndLayoutSubviews() {
        view.addSubview(emailField)
        emailField.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide).offset(20)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        
        view.addSubview(passwordField)
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(15)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.height.equalTo(0)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(authButton)
        authButton.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(100)
        }
    }
    
    // MARK: Actions
    @objc private func dismissTapped() {
        presenter.dismissTapped()
    }
    
    @objc private func authTapped() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        presenter.authTapped()
    }
}

// MARK: - AuthViewProtocol
extension AuthViewController: AuthViewProtocol {
    func startActivityIndication() {
        activityIndicator.startAnimating()
        activityIndicator.snp.remakeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.height.equalTo(activityIndicator.snp.width)
            make.centerX.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut]) {
            self.activityIndicator.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func stopActivityIndication() {
        activityIndicator.stopAnimating()
        activityIndicator.snp.remakeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(10)
            make.height.equalTo(0)
            make.centerX.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut]) {
            self.activityIndicator.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === emailField {
            presenter.emailChanged(to: textField.text ?? "")
        } else {
            presenter.passwordChanged(to: textField.text ?? "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailField {
            presenter.emailChanged(to: textField.text ?? "")
            passwordField.becomeFirstResponder()
        } else {
            presenter.passwordChanged(to: textField.text ?? "")
            passwordField.resignFirstResponder()
            presenter.authTapped()
        }
        
        return true
    }
}

// MARK: - Alertable
extension AuthViewController: Alertable { }
