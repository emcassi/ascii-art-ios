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
    
    let image: Image<RGBA<UInt8>>
    
    var asciiText: String = ""
    
    let asciiLabel: UITextView = {
        let label = UITextView()
        label.backgroundColor = .clear
        label.textColor = .white
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "bg")
        
        view.addSubview(asciiLabel)
        
        asciiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        asciiLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        asciiLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        asciiLabel.heightAnchor.constraint(equalTo: asciiLabel.heightAnchor, multiplier: 0.75).isActive = true
        
    }
    
    init(image: UIImage){
        self.image = Image(uiImage: image)
        super.init(nibName: nil, bundle: nil)
                
        let resized = resize(image: self.image)
        let lum = rgbToLuminance(image: resized)
        for x in 0..<lum.count {
            for y in 0..<lum[x].count {
                asciiText.append(selectAsciiChar(value: lum[x][y]))
            }
            asciiText.append("\n")
        }
        
        asciiLabel.text = asciiText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resize(image: Image<RGBA<UInt8>>) -> Image<RGBA<UInt8>> {
        let ratio = CGFloat(image.height) / CGFloat(image.width)
        
        let maxWidth = 100
        let height = Int(CGFloat(maxWidth) * ratio)
        print("WIDTH: \(maxWidth)")
        print("HEIGHT: \(height)")
        return image.resizedTo(width: maxWidth, height: Int(height))
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
