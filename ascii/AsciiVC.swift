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
    
    let uiImage: UIImage

    var asciiText: String = ""
    
    let asciiLabel: UITextView = {
        let label = UITextView()
//        label.backgroundColor = .white
//        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.font = .monospacedSystemFont(ofSize: 4, weight: .regular)
        label.text = """
               ......                  .............
            .....;;...                ................
         .......;;;;;/mmmmmmmmmmmmmm\\/..................
       ........;;;mmmmmmmmmmmmmmmmmmm.....................
     .........;;m/;;;;\\mmmmmm/;;;;;\\m......................
  ..........;;;m;;mmmm;;mmmm;;mmmmm;;m......................
..........;;;;;mmmnnnmmmmmmmmmmnnnmmmm\\....................
.........  ;;;;;n/#####\\nmmmmn/#####\\nmm\\.................
.......     ;;;;n##...##nmmmmn##...##nmmmm\\.............
....        ;;;n#.....|nmmmmn#.....#nmmmmm,l.........
 ..          mmmn\\.../nmmmmmmn\\.../nmmmm,m,lll.....
          /mmmmmmmmmmmmmmmmmmmmmmmmmmm,mmmm,llll..
      /mmmmmmmmmmmmmmmmmmmmmmm\\nmmmn/mmmmmmm,lll/
   /mmmmm/..........\\mmmmmmmmmmnnmnnmmmmmmmmm,ll
  mmmmmm|...........|mmmmmmmmmmmmmmmmmmmmmmmm,ll
  \\mmmmmmm\\......./mmmmmmmmmmmmmmmmmmmmmmmmm,llo
    \\mmmmmmm\\.../mmmmmmmmmmmmmmmmmmmmmmmmmm,lloo
      \\mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm,ll/oooo
         \\mmmmmmmmmmll..;;;.;;;;;;/mmm,lll/oooooo\\
                   ll..;;;.;;;;;;/llllll/ooooooooo
                   ll.;;;.;;;;;/.llll/oooooooooo..o
                   ll;;;.;;;;;;..ll/ooooooooooo...oo
                   \\;;;;.;;;;;..ll/ooooo...ooooo..oo\\
                 ;;;;;;;;;;;;..ll|oooo.....oooooooooo
                ;;;;;;.;;;;;;.ll/oooo.....ooooooo....\\
                ;;;;;.;;;;;;;ll/ooooooooooooo.....oooo
                 \\;;;.;;;;;;/oooooooooooo.....oooooooo\\
                  \\;;;.;;;;/ooooooooo.....ooooooooooooo
                    \\;;;;/ooooooo.....ooooooooooo...ooo\\
                    |o\\;/oooo.....ooooooooooooo......ooo
                    oooooo....ooooooooooooooooooo.....oo\\
                   oooo....oooooooooooooooooooooooo..oooo
                  ___.oooooooooooooo....ooooooooooooooooo\\
                 /XXX\\oooooooooooo.....ooooooooooooooooooo
                 |XXX|ooooo.oooooo....ooooooooooooooooooooo
               /oo\\X/oooo..ooooooooooooooooooo..oooooooooooo
             /ooooooo..ooooo..oooooooooooooo.....ooooooooo...
           /ooooo...ooooo.....oooooooooooo.......ooooooo.....o
"""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Copy", for: .normal)
        button.setTitleColor(UIColor(named: "bg"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(copyPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg")
        
        view.addSubview(asciiLabel)
        view.addSubview(nextButton)
                
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true

        asciiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        asciiLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        asciiLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        asciiLabel.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -25).isActive = true

        
        let newSize = resize()
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        uiImage.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let newImage = newImage {
            let image = Image<RGBA<UInt8>>(uiImage: newImage)
            let lum = rgbToLuminance(image: image)
            print(lum.count)
            for x in 0..<lum.count {
                for y in 0..<lum[x].count {
                    asciiText.append(selectAsciiChar(value: lum[x][y]))
                }
                asciiText.append("\n")
            }
            
            asciiLabel.text = asciiText
        }
    }
    
    init(image: UIImage){
        self.uiImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resize() -> CGSize {
        let ratio = CGFloat(uiImage.size.height) / CGFloat(uiImage.size.width)
        
        let maxWidth: CGFloat = 100
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
    
    @objc func copyPressed(){
        
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
