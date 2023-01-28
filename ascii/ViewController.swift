//
//  ViewController.swift
//  ascii
//
//  Created by Alex Wayne on 1/26/23.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let defaultQuality: Float = 200
    let minQuality: Float = 50
    let maxQuality: Float = 1000
    
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
    
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let qualityLabel: UILabel = {
        let label = UILabel()
        label.text = "Quality"
        label.textColor = .white
        label.isHidden = true
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.isHidden = true
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
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
        
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        slider.minimumValue = minQuality
        slider.maximumValue = maxQuality
        slider.setValue(defaultQuality, animated: false)
        
        view.addSubview(instructions)
        view.addSubview(imageView)
        
        view.addSubview(bottomView)
        
        bottomView.addSubview(cameraButton)
        bottomView.addSubview(galleryButton)
        bottomView.addSubview(qualityLabel)
        bottomView.addSubview(slider)
        bottomView.addSubview(nextButton)
                
        setupSubviews()
    }

    func setupSubviews(){
        
        instructions.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75).isActive = true
        instructions.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        instructions.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true

        imageView.topAnchor.constraint(equalTo: instructions.bottomAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        bottomView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
                        
        qualityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        qualityLabel.bottomAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: -5).isActive = true
        qualityLabel.widthAnchor.constraint(equalTo: slider.widthAnchor).isActive = true
        
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slider.topAnchor.constraint(equalTo: qualityLabel.bottomAnchor, constant: 5).isActive = true
        slider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        
        cameraButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 5).isActive = true
        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width / 6).isActive = true
        
        galleryButton.topAnchor.constraint(equalTo: cameraButton.topAnchor).isActive = true
        galleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width / 6).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -15).isActive = true

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
        print("SDF")
        if let image = imageView.image {
            present(AsciiVC(parent: self, image: image, quality: slider.value), animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imageView.image = image
            qualityLabel.isHidden = false
            slider.isHidden = false
            nextButton.isHidden = false
        }
        picker.dismiss(animated: true)
    }

}

