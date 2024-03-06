//
//  DetailVC.swift
//  Passember
//
//  Created by Raghav Vashisht on 27/06/17.
//  Copyright © 2017 Raghav Vashisht. All rights reserved.
//

import UIKit
import RealmSwift

class DetailVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imgPick: UIImageView!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var showPassSwitch: UISwitch!
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
    
    
    var item:Item!
    var itemToEdit: Item?
    var realm:Realm!
    var imagepicker: UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        websiteField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        item = Item()
        realm = try! Realm()
        if itemToEdit != nil { loadItemData() }
        if itemToEdit == nil { deleteBtn.isEnabled = false }
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        }
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func imgUploadPressed(_ sender: UIButton) {
        present(imagepicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgPick.image = img
            if itemToEdit == nil {
                self.item.thumbImg = saveImageDocumentDirectory(img: img)
            } else if itemToEdit != nil {
                try! realm.write {
                    self.itemToEdit!.thumbImg = saveImageDocumentDirectory(img: img)
                }
                
            }
            
        }
        imagepicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showHidePass(_ sender: UISwitch) {
        
        if showPassSwitch.isOn {
            passwordField.isSecureTextEntry = false
        } else {
            passwordField.isSecureTextEntry = true
        }
        
    }
    
    func loadItemData() {
        websiteField.text = itemToEdit?.websiteName
        usernameField.text = itemToEdit?.username
        passwordField.text = itemToEdit?.password
        getImage(path: (itemToEdit?.thumbImg)!)
    }
    
    func getImage(path: String){
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path){
            self.imgPick.image = UIImage(contentsOfFile: path)
        }else{
            imgPick.image = UIImage(named: "imagePick")
        }
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            try! realm.write {
             realm.delete(itemToEdit!)
             }
            navigationController?.popViewController(animated: true)
            DataManager.shared.firstVC.fetchData()
            DataManager.shared.firstVC.tableView.reloadData()
        } else {
            
        }
    }
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
        if itemToEdit != nil {
            try! realm.write {
                itemToEdit!.websiteName = websiteField.text!
                itemToEdit!.username = usernameField.text!
                itemToEdit!.password = passwordField.text!
            }
            
        } else {
            if websiteField.text == nil {
                websiteField.text = ""
            }
            if usernameField.text == nil {
                usernameField.text = ""
            }
            if passwordField.text == nil {
                passwordField.text = ""
            }
            if imgPick.image == nil {
                imgPick.image = UIImage(named: "imagePick")
            }
            
            item.websiteName = websiteField.text!
            item.username = usernameField.text!
            item.password = passwordField.text!
            try! realm.write {
                realm.add(item)
            }
        }
        
        navigationController?.popViewController(animated: true)
        DataManager.shared.firstVC.fetchData()
        DataManager.shared.firstVC.tableView.reloadData()
    }
    
    func saveImageDocumentDirectory(img: UIImage) -> String{
        let uuid = UUID().uuidString
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(uuid)
        let imageData = UIImageJPEGRepresentation(img, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        return paths
    }
    
    
}
