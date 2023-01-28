//
//  AsciiVC.swift
//  ascii
//
//  Created by Alex Wayne on 1/26/23.
//

import Foundation
import UIKit
import SwiftImage

class AsciiVC: UIViewController {
    
    let p: ViewController
    let uiImage: UIImage
    let quality: Float

    var asciiText: String = ""
    
    let textView: UITextView = {
        let label = UITextView()
        label.backgroundColor = UIColor(named: "accent")
//        label.textColor = .white
        label.isEditable = false
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.font = .monospacedSystemFont(ofSize: 0.5, weight: .regular)
//        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "bg"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(named: "accent")
        button.layer.cornerRadius = 15
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        return button
    }()
    
    let spinner: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .medium)
        av.color = .white
        av.hidesWhenStopped = true
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg")
        
        let fontSize: CGFloat = CGFloat(400 / Float(quality))
        print(fontSize)
        textView.font = .monospacedSystemFont(ofSize: fontSize, weight: .regular)
        
        view.addSubview(textView)
        view.addSubview(closeButton)
        view.addSubview(spinner)
                
        closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true

        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -25).isActive = true

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        spinner.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let newSize = self.resize()
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.uiImage.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            var text = ""
            
            if let newImage = newImage {
                let image = Image<RGBA<UInt8>>(uiImage: newImage)
                let lum = self.rgbToLuminance(image: image)
                for x in 0..<lum.count {
                    for y in 0..<lum[x].count {
                        text.append(self.selectAsciiChar(value: lum[x][y]))
                    }
                    text.append("\n")
                }
                
                DispatchQueue.main.async {
                    self.textView.text = text
                    self.spinner.stopAnimating()
                    self.textView.backgroundColor = .white
                    self.closeButton.backgroundColor = .white
                    self.closeButton.setTitle("Close", for: .normal)
                    self.closeButton.isUserInteractionEnabled = true
                }
                
            }
        }
    }
    
    init(parent: ViewController, image: UIImage, quality: Float){
        self.p = parent
        self.uiImage = image
        self.quality = quality
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resize() -> CGSize {
        let ratio = CGFloat(uiImage.size.height) / CGFloat(uiImage.size.width)
        
        let maxWidth: CGFloat = CGFloat(quality)
        if uiImage.size.width > maxWidth {
            let height = CGFloat(maxWidth) * ratio
            return CGSize(width: maxWidth, height: height)

        } else {
            return CGSize(width: uiImage.size.width, height: uiImage.size.height)
        }
    }
    
    
    func rgbToLuminance(image: Image<RGBA<UInt8>>) -> [[Float]] {
        var arr: [[Float]] = Array(repeating: Array<Float>(repeating: 0, count: image.width), count: image.height)
            
        for x in image.xRange {
            for y in image.yRange {
                // formula: https://stackoverflow.com/questions/596216/formula-to-determine-perceived-brightness-of-rgb-color
                
                let red = Double(image[x, y].red) * 0.2126
                let green = Double(image[x, y].green) * 0.7152
                let blue = Double(image[x, y].blue) * 0.0722
                let luminance = Float(red + green + blue)
                
                arr[y][x] = luminance
            }
        }
        
        return arr
    }
    
    func selectAsciiChar(value: Float) -> String {
        let options = "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_+~<>i!lI;:,\"^`'. "
        
        let index = Int((value / 255.0) * Float(options.count))
        return options[index]
    }
    
    @objc func screenPressed(){
        print("GO AWAY")
        textView.resignFirstResponder()
    }
    
    @objc func closePressed(){
        dismiss(animated: true)
    }
}


extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
