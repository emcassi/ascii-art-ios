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
    
    let asciiLabel: UITextView = {
        let label = UITextView()
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = .monospacedSystemFont(ofSize: 8, weight: .regular)
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
        asciiLabel.heightAnchor.constraint(equalTo: asciiLabel.widthAnchor).isActive = true
    }
    
    init(image: UIImage){
        self.image = Image(uiImage: image)
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rgbToLuminance() -> Image<RGBA<CGFloat>> {
        var newImage = Image<RGBA<CGFloat>>(width: image.width, height: image.height, pixel: RGBA(gray: 0, alpha: 1))
        
        for x in image.xRange {
            for y in image.yRange {
                // formula: https://stackoverflow.com/questions/596216/formula-to-determine-perceived-brightness-of-rgb-color
                
                let red = Double(image[x, y].red) * 0.2126
                let green = Double(image[x, y].green) * 0.7152
                let blue = Double(image[x, y].blue) * 0.0722
                let luminance = CGFloat(red + green + blue)
                
                newImage[x, y] = RGBA(gray: luminance, alpha: 1)
            }
        }
        
        return newImage
    }
    
    func selectAsciiChar(value: CGFloat) -> Character {
        let options = "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_+~<>i!lI;:,\"^`'. "
        return "a"
    }
}
