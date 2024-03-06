//
//  SettingsVC.swift
//  Passember
//
//  Created by Raghav Vashisht on 03/07/17.
//  Copyright © 2017 Raghav Vashisht. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsVC: UIViewController {
    
    @IBOutlet weak var uiSwitch: UISwitch!
    
    var password:Password!
    var realm:Realm!
    override func viewDidLoad() {
        super.viewDidLoad()
        password = Password()
        realm = try! Realm()
        loadPass()
        if password.password == "" { uiSwitch.isOn = false }
        else { uiSwitch.isOn = true }
    }
    @IBAction func aboutPressed(_ sender: UIButton) {
        let alert1 = UIAlertController(title: "Welcome to Passember!", message: "\n A simple app to organise all of your passwords in one place! \n\n To Get Started:\n Just tap on the '+' button on the top right corner of the Home screen.", preferredStyle: .alert)
        alert1.addAction(UIAlertAction(title: "Cool!", style: .default, handler: nil))
        self.present(alert1, animated: true, completion: nil)
        
    }
    
    @IBAction func followOnGitPressed(_ sender: UIButton) {
        let options = [UIApplicationOpenURLOptionUniversalLinksOnly : false]
        UIApplication.shared.open(URL(string: "https://github.com/rv2011")!, options: options, completionHandler: nil)
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        if uiSwitch.isOn {
            let alert = UIAlertController(title: "Set Password", message: "\n Enter Password", preferredStyle: .alert)
            alert.addTextField(configurationHandler: configureTextField1)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
                self.doneBtnPressed(alert: alert)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in self.uiSwitch.isOn = false }))
            self.present(alert, animated: true, completion: nil)
        }
        else if uiSwitch.isOn == false {
            
            let alert = UIAlertController(title: "Disable Password", message: "\n Enter Current password", preferredStyle: .alert)
            alert.addTextField(configurationHandler: configureTextField)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
                self.removeDoneBtnPressed(alert: alert)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in self.uiSwitch.isOn = true }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func doneBtnPressed(alert: UIAlertController!) {
        let newTextField = alert.textFields![0]
        if self.password.password == "" {
            try! self.realm.write {
                self.password.password = newTextField.text!
                realm.add(self.password)
            }
        }
    }
    func removeDoneBtnPressed(alert: UIAlertController!) {
        let currentTextField = alert.textFields![0]
        if currentTextField.text == self.password.password {
            try! realm.write {
                self.password.password = ""
                realm.add(password)
            }
        }else {
            let alert = UIAlertController(title: "Wrong Current Password!", message: "\n Please Enter correct Current password in the 'Enter Current Passowrd' Field", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func configureTextField(textField: UITextField!){
        textField.placeholder = "Enter Currect Password"
        textField.isSecureTextEntry = true
    }
    func configureTextField1(textField: UITextField!){
        textField.placeholder = "Enter New Password"
        textField.isSecureTextEntry = true
    }
    func loadPass() {
        let pass = Array(realm.objects(Password.self))
        if pass.count == 1 {
            self.password = pass[0]
        }
    }
    func savePass() {
        try! realm.write {
            realm.add(password)
        }
    }
}
