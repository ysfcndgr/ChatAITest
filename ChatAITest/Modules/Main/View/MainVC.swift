//
//  MainVC.swift
//  Capstone Project Cem
//
//  Created by Can on 8.06.2024.
//

import UIKit
import GoogleGenerativeAI
import AVFoundation

final class MainVC: UIViewController {
    
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView! // create a singleton
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet weak var stackViewBottomCons: NSLayoutConstraint!
    
    var viewModel: MainViewModelProtocol? {
        didSet {
            viewModel?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        navBarActivityIndicatorSettings()
        setupNavbar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.stackViewBottomCons.constant = -keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.stackViewBottomCons.constant = 8
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupNavbar(){
           title = "Chat AI"
           navigationItem.hidesBackButton = true
           let appearance = UINavigationBarAppearance()
           appearance.configureWithOpaqueBackground()
           navigationController?.navigationBar.standardAppearance = appearance
           navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .blue
   }

    @IBAction func sendButtonTapped(_ sender: Any) {
        Task {
            let txt = textField.text
            sendButton.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            textField.text = ""
            viewModel?.chatList.append(.init(response: txt ?? "", type: .user))
            self.handle(notify: .reloadTableView)
            let result = await viewModel?.generateTextForPrompt(text: txt ?? "")
            switch result {
            case .success:
                print("başarılı")
            case .error:
                print("hatalı")
            case .empty:
                print("boş")
            case .none:
                print("none")
            }
            messageSound()
            chatSettings()
        }
    }
    
}

//MARK: - Private Funcs
@objc private
extension MainVC {
    
    func chatSettings(){
        activityIndicator.stopAnimating()
        sendButton.isHidden = false
        activityIndicator.isHidden = true
        let indexPath = IndexPath(row: (viewModel?.chatList.count ?? 0) - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    func messageSound(){
        let messageSound: SystemSoundID = 1007
        AudioServicesPlaySystemSound(messageSound)
    }
    

    func navBarActivityIndicatorSettings() {
        //navigationController?.navigationBar.isHidden = true
        activityIndicator.isHidden = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.chatList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let chatItem = viewModel.chatList[indexPath.row]

        switch chatItem.type {
        case .ai:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainCell.self), for: indexPath) as? MainCell {
                cell.configure(with: chatItem.response)
                return cell
            }
        case .user:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserResponseCell.self), for: indexPath) as? UserResponseCell {
                cell.configure(with: chatItem.response)
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

private 
extension MainVC {
    func registerCells() {
        let mainCellIdentifier = String(describing: MainCell.self)
        let mainCellNib = UINib(nibName: mainCellIdentifier, bundle: .main)
        tableView.register(mainCellNib, forCellReuseIdentifier: mainCellIdentifier)

        let userResponseCellIdentifier = String(describing: UserResponseCell.self)
        let userResponseCellNib = UINib(nibName: userResponseCellIdentifier, bundle: .main)
        tableView.register(userResponseCellNib, forCellReuseIdentifier: userResponseCellIdentifier)
    }
}

extension MainVC: MainViewModelDelegate {
    func handle(notify: MainViewNotify) {
        switch notify {
        case .reloadTableView:
            tableView.reloadData()
        }
    }
}
