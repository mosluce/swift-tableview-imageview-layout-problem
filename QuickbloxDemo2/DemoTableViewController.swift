//
//  DemoTableViewController.swift
//  QuickbloxDemo2
//
//  Created by 默司 on 2016/12/9.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit
import PermissionScope
import MobileCoreServices

class DemoTableViewController: UIViewController {

    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!

    let scope = PermissionScope()
    let imagePicker = UIImagePickerController()
    
    var data = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didViewTap(_:))))
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(cellType: TextTableViewCell.self)
        self.tableView.register(cellType: ImageTableViewCell.self)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.messageField.delegate = self
        self.messageField.enablesReturnKeyAutomatically = true
        self.messageField.addTarget(self, action: #selector(didMessageChange(_:)), for: .editingChanged)
        
        self.imagePicker.delegate = self
        self.imagePicker.mediaTypes = [kUTTypeImage as String]
        
        self.scope.viewControllerForAlerts = scope as UIViewController
        
        self.didMessageChange(self.messageField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willKeyboardShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willKeyboardHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func action(_ sender: Any) {
        if let title = self.actionButton.title(for: .normal) {
            if title == "Send" {
                self.data.append(self.messageField.text ?? "")
                self.messageField.text = nil
                self.tableView.insertRows(at: [IndexPath(row: data.count - 1, section: 0)], with: .bottom)
            }
            
            if title == "Share" {
                self.presentImagePicker()
            }
        }
    }
    
    func presentImagePicker()  {
        UIAlertController(title: "選擇來源", message: nil, preferredStyle: .actionSheet)
            .addAction(title: "相機", style: .default, handler: {[unowned self] (_) in
                self.presentCamera()
            })
            .addAction(title: "照片", style: .default, handler: {[unowned self] (_) in
                self.presentPhotoLibrary()
            })
            .present()
    }
    
    func presentCamera() {
        self.scope.onAuthChange = {[unowned self] (finish, results) in
            if finish && self.scope.statusCamera() == .authorized {
                self.presentCamera()
            }
        }
        
        switch self.scope.statusCamera() {
        case .authorized:
            break
        default:
            return scope.requestCamera()
        }
        
        self.imagePicker.sourceType = .camera
        self.present(self.imagePicker, animated: true)
    }
    
    func presentPhotoLibrary() {
        self.scope.onAuthChange = {[unowned self] (finish, results) in
            if finish && self.scope.statusPhotos() == .authorized {
                self.presentPhotoLibrary()
            }
        }
        
        switch self.scope.statusPhotos() {
        case .authorized:
            break
        default:
            return scope.requestPhotos()
        }
        
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true)
    }
}

extension DemoTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = data[indexPath.row] as? String {
            let cell = tableView.dequeueReusableCell(with: TextTableViewCell.self, for: indexPath)
            cell.item = item
            return cell
        }
        
        if let item = data[indexPath.row] as? UIImage {
            let cell = tableView.dequeueReusableCell(with: ImageTableViewCell.self, for: indexPath)
            cell.item = item
            return cell
        }
        
        fatalError("Data is not supported")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundView?.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
    }
}

extension DemoTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            return true
        }
        
        return false
    }
}

extension DemoTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imagePicker.dismiss(animated: true)
        
        if let image = (info[UIImagePickerControllerOriginalImage] as? UIImage)?.resize(max: 512) {
            self.data.append(image)
            self.tableView.insertRows(at: [IndexPath(row: data.count - 1, section: 0)], with: .bottom)
        }
    }
}

extension DemoTableViewController {
    func willKeyboardShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {[unowned self] () in
            self.keyboardHeightConstraint.constant = frame.height
            self.view.layoutIfNeeded()
        })
    }
    
    func willKeyboardHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {[unowned self] () in
            self.keyboardHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
}

extension DemoTableViewController {
    
    func didViewTap(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func didMessageChange(_ sender: Any) {
        if let text = self.messageField.text, !text.isEmpty {
            return self.actionButton.setTitle("Send", for: .normal)
        }
        
        self.actionButton.setTitle("Share", for: .normal)
    }
}
