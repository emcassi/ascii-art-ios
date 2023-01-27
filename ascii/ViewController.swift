//
//  ViewController.swift
//  ascii
//
//  Created by Alex Wayne on 1/26/23.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ascii Art"
        label.font = .systemFont(ofSize: 42, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instructions: UILabel = {
        let label = UILabel()
        label.text = "Select an image to convert"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(named: "accent")
        iv.layer.cornerRadius = 15
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let cameraButton: CircleButton = {
        let button = CircleButton("camera")
        button.tintColor = .white
        button.addTarget(self, action: #selector(cameraPressed), for: .touchUpInside)
        return button
    }()
    
    let galleryButton: CircleButton = {
        let button = CircleButton("photo.on.rectangle")
        button.tintColor = .white
        button.addTarget(self, action: #selector(galleryPressed), for: .touchUpInside)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(named: "bg"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        return button
    }()
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "bg")
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        view.addSubview(titleLabel)
        view.addSubview(instructions)
        view.addSubview(imageView)
        view.addSubview(cameraButton)
        view.addSubview(galleryButton)
        view.addSubview(nextButton)
        
        setupSubviews()
    }

    func setupSubviews(){
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        instructions.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        instructions.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        instructions.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true

        imageView.topAnchor.constraint(equalTo: instructions.bottomAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        
        cameraButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -25).isActive = true
        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width / 6).isActive = true
        
        galleryButton.bottomAnchor.constraint(equalTo: cameraButton.bottomAnchor).isActive = true
        galleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width / 6).isActive = true
    }
    
    @objc func cameraPressed(){
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true)
    }
    
    @objc func galleryPressed(){
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
        
    }
    
    @objc func nextPressed(){
        if let image = imageView.image {
            present(AsciiVC(image: image), animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.imageView.image = image
            nextButton.isHidden = false
        }
        picker.dismiss(animated: true)
    }

}

