//
//  LoginViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import Foundation
import PromiseKit
import SwiftUI

class ModelData : ObservableObject {
    @Published var email  = ""
    @Published var password = ""
    @Published var isSignUp = false
    @Published var email_SignUp = ""
    @Published var password_SignUp = ""
    @Published var reEnterPassword = ""
    
    @Published var alert : String? = nil
    
    @Published var isLoading = false
    
    @Published var loggedIn = false
    
    let db = Database()
    
    init() {
        //print(UserDefaults.standard.bool(forKey: "LoggedIn"))
    }
    
    func signUp(){
        alert = nil
        /* Check If The Email is in the Valid Format*/
        if(!db.Account.isValidEmail(email_SignUp)) { alert="Please Enter a Valid Email"; return}
        else if(password_SignUp.length == 0) { alert="Please Enter a Password"; return}
        else if(reEnterPassword.length == 0) { alert="Please Re-Enter Your Password"; return }
        else if(password_SignUp.length < 7) { alert = "Passwords Must be at Least 7 Characters Long"; return}
        else if(reEnterPassword != password_SignUp) { alert = "Passwords Do Not Match"; return}
        
        withAnimation{ isLoading.toggle() }
        
        _ = db.Account.createAccount(email: email_SignUp, password: password_SignUp, completion: { [self] (response, error) in
            withAnimation{ isLoading.toggle() }
            
            if(error != nil && error! is RuntimeError){
                alert = "Oops, \((error! as! RuntimeError).localizedDescription)";
                password_SignUp = ""
                reEnterPassword = ""
                return
            }
            else if(response == .success){
                let ud = UserDefaults.standard
                ud.setValue(true, forKey: "LoggedIn")
                self.loggedIn = true
                return
            }
            else if(response == .customResponse1){
                alert = "An Account with This Email Already Exists"
                password_SignUp = ""
                reEnterPassword = ""
                return
            }
            
            else {
                alert = "Oops, Something Unknown Happened"
                password = ""
                return
            }
            
        })
        
    }
    func login(){
        //Verify All Input Fields Are Valid
        alert = nil
        if email.trim() == "" || password.trim() == "" {
            alert = "Please Fill Out All Fields"
            password = ""
            return
        }
        withAnimation{ isLoading.toggle() }
        
        _ = db.Account.validateLogin(email: email, password: password, completion: { [self] (response, error )  in
            withAnimation{ isLoading.toggle() }
            if(error != nil && error! is RuntimeError){
                alert = "Oops, \((error! as! RuntimeError).localizedDescription)";
                password = ""
                return
            }
            else if (response == .fail) {
                alert = "Incorrect Email or Password";
                password = ""
                return
            }
            else if (response == .success) {
                let ud = UserDefaults.standard
                ud.setValue(true, forKey: "LoggedIn")
                self.loggedIn = true
                return
            }
            else {
                alert = "Oops, Something Unknown Happened"
                password = ""
                return
            }
        })
    }
    func forgotPassword(){
        
    }
}
