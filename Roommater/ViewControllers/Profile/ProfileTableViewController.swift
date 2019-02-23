//
//  ProfileTableViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/17/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var profilePictureView: UIImageView!
    
    @IBOutlet weak var fullnameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var pictureEditButton: UIButton!
    var currentUser = InternalUserController.shared.loggedInUser
    var place : Place?
    var fetchedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        updateViews()
        
        FirebaseStorageController.fetchImage(forUser: currentUser!) { (image) in
            guard let image = image else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
            DispatchQueue.main.async {
                self.fetchedImage = image
                self.profilePictureView.image = image
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    func updateViews() {
        guard let currentUser = currentUser else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
        fullnameLabel.text = currentUser.fullname
        emailLabel.text = currentUser.emailAddress
        phoneNumberLabel.text = currentUser.phoneNumber
        profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width/2
        pictureEditButton.layer.cornerRadius = pictureEditButton.frame.size.width/2
        profilePictureView.layer.masksToBounds = true
        
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.isNavigationBarHidden = false
//        if let image = fetchedImage {
//            profilePictureView.image = image
//        }
    }
    
    // MARK: - Table view data source
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func editProfilePictureButtonTapped(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        
        let actionSheet = UIAlertController(title: "Add/Edit Profile Photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            actionSheet.addAction(UIAlertAction(title: "Upload a photo", style: .default, handler: { (_) in
                
                self.present(imagePickerController, animated: true, completion: nil)
                
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            actionSheet.addAction(UIAlertAction(title: "Take a picture", style: .default, handler: { (nil) in
                
                self.present(imagePickerController, animated:  true, completion: nil)
                
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Delete Current Picture ", style: .destructive, handler: { (_) in
            
            self.profilePictureView.image = nil
            //TODO: internalUser.profileImage = nil
            //TODO: firestore.internalUser.profileImage = nil
        }))
        present(actionSheet, animated: true)
    }
    
    @IBAction func deleteMyAccountButtonTapped(_ sender: Any) {
        guard let currentUser = currentUser else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
        
        let alertController = UIAlertController(title: "Are you Sure you want to delete your account?", message: "This action cannot be undone", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "Yes, I'm Sure", style: .destructive) { (_) in
            
            if let place = self.place {
                PlaceController.shared.updateRemoveTenantUid(toPlace: place, tenantUid: currentUser.uid, completion: { (place) in
                    InternalUserController.shared.leavePlace(forTenant: currentUser, completion: { (user) in
                        guard let user = user else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                        InternalUserController.shared.loggedInUser = user
                    })
                })
            } else {
                InternalUserController.shared.updateDeleteUser(withUid: currentUser.uid, completion: { (success) in
                    if success {
                        print("User \(currentUser.fullname) was deleted")
                    } else {
                        print("\(#file) \(#line): Something went wrong and user wasn't deleted ")
                    }
                })
            }
        }
        alertController.addAction(cancelButton)
        alertController.addAction(yesButton)
        
        present(alertController,animated: true,completion: nil)
    }
    
    @IBAction func leaveHouseButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Are you Sure you want to leave your house?", message: "This will delete and redistribute all tasks and events you have associated with your house. This action cannot be undone", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "Yes, I'm Sure", style: .destructive) { (_) in
            //TODO: Leave house code goes here
            guard let currentUser = self.currentUser else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
            InternalUserController.shared.leavePlace(forTenant: currentUser, completion: { (user) in
                guard let user = user else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                self.currentUser = user
                guard let place = PlaceController.shared.currentPlace else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                
                PlaceController.shared.updateRemoveTenantUid(toPlace: place, tenantUid: user.uid, completion: { (place) in
                    guard let place = place else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                    PlaceController.shared.currentPlace = place
                })
            })
        }
        alertController.addAction(cancelButton)
        alertController.addAction(yesButton)
        
        present(alertController,animated: true,completion: nil)
    }
    
   
    @IBAction func logOutButtonTapped(_ sender: Any) {
        InternalUserController.shared.logOut()
        tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            profilePictureView.image = photo
            
            FirebaseStorageController.uploadImage(photo, forUser: currentUser!) { (imageUrlString) in
                
                guard let imageUrlString = imageUrlString else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                
                InternalUserController.shared.updateUserImageUrl(forUser: self.currentUser!, imageUrlString: imageUrlString, completion: { (user) in
                    
                    guard let user = user else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                    InternalUserController.shared.loggedInUser = user
                })
            }
            
            
            // TODO: send photo data to firestore
            //internalUser.profileImage = photo
            
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // TODO : Add profile image
}

