//
//  ViewController.swift
//  Doom Fire Effect
//
//  Created by Lucas Pelinzon on 05/02/19.
//  Copyright © 2019 Lucas Pelinzon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Variables
    var firePixelsArray: [Int] = []
    let colors: [UIColor] = [#colorLiteral(red: 0.02745098039, green: 0.02745098039, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.1215686275, green: 0.02745098039, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.1843137255, green: 0.05882352941, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.2784313725, green: 0.05882352941, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.3411764706, green: 0.09019607843, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.4039215686, green: 0.1215686275, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.4666666667, green: 0.1215686275, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.5607843137, green: 0.1529411765, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.6235294118, green: 0.1843137255, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.6862745098, green: 0.2470588235, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.7490196078, green: 0.2784313725, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.7803921569, green: 0.2784313725, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.8745098039, green: 0.3098039216, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.8745098039, green: 0.3411764706, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.8745098039, green: 0.3411764706, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.8431372549, green: 0.3725490196, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.8431372549, green: 0.3725490196, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 0.8431372549, green: 0.4039215686, blue: 0.05882352941, alpha: 1),#colorLiteral(red: 0.8117647059, green: 0.4352941176, blue: 0.05882352941, alpha: 1),#colorLiteral(red: 0.8117647059, green: 0.4666666667, blue: 0.05882352941, alpha: 1),#colorLiteral(red: 0.8117647059, green: 0.4980392157, blue: 0.05882352941, alpha: 1),#colorLiteral(red: 0.8117647059, green: 0.5294117647, blue: 0.09019607843, alpha: 1),#colorLiteral(red: 0.7803921569, green: 0.5294117647, blue: 0.09019607843, alpha: 1),#colorLiteral(red: 0.7803921569, green: 0.5607843137, blue: 0.09019607843, alpha: 1),#colorLiteral(red: 0.7803921569, green: 0.5921568627, blue: 0.1215686275, alpha: 1),#colorLiteral(red: 0.7490196078, green: 0.6235294118, blue: 0.1215686275, alpha: 1),#colorLiteral(red: 0.7490196078, green: 0.6235294118, blue: 0.1215686275, alpha: 1),#colorLiteral(red: 0.7490196078, green: 0.6549019608, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.7490196078, green: 0.6549019608, blue: 0.1529411765, alpha: 1),#colorLiteral(red: 0.7490196078, green: 0.6862745098, blue: 0.1843137255, alpha: 1),#colorLiteral(red: 0.7176470588, green: 0.6862745098, blue: 0.1843137255, alpha: 1),#colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.1843137255, alpha: 1),#colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.2156862745, alpha: 1),#colorLiteral(red: 0.8117647059, green: 0.8117647059, blue: 0.4352941176, alpha: 1),#colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.6235294118, alpha: 1),#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.7803921569, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    var fireWidth = 20
    var fireHeight = 36
    var windDirection = 1
    var sourceIntensity = 36
    
    //MARK: - Outlets
    @IBOutlet weak var fireCollectionView: UICollectionView!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fireCollectionView.delegate = self
        fireCollectionView.dataSource = self
        
        createFireDataStructure()
        createFireSource(intensity: sourceIntensity)
        
        Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(calculateFirePropagation), userInfo: nil, repeats: true)
        
        //MARK: Gesture recognizers
        let gestureDirections: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        for direction in gestureDirections {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.gestureHandler))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
        
    }
    
    //MARK: - Custom Methods
    @objc func gestureHandler(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                print("right")
                switch windDirection{
                case 0:
                    windDirection = 1
                case 1:
                    windDirection = 2
                case 2:
                    windDirection = 2
                default:
                    break
                }
            case UISwipeGestureRecognizer.Direction.left:
                print("left")
                switch windDirection{
                case 0:
                    windDirection = 0
                case 1:
                    windDirection = 0
                case 2:
                    windDirection = 1
                default:
                    break
                }
            case UISwipeGestureRecognizer.Direction.up:
                if(sourceIntensity < 33){
                    sourceIntensity += 4
                    print(sourceIntensity)
                    createFireSource(intensity: sourceIntensity)
                }
                
            case UISwipeGestureRecognizer.Direction.down:
                if(sourceIntensity > 3){
                    sourceIntensity -= 4
                    print(sourceIntensity)
                    createFireSource(intensity: sourceIntensity)
                }
            default:
                break
            }
        }
    }
    
    func createFireDataStructure() {
        //columnAmount = Int(view!.frame.width / (view!.frame.height / 36))
        let cellAmount = fireHeight * fireWidth
        for _ in 0..<cellAmount {
            firePixelsArray.append(0)
        }
    }
    
    func createFireSource(intensity: Int) {
        for column in 0..<fireWidth {
            let overflowPixelIndex = fireWidth * fireHeight
            let pixelIndex = (overflowPixelIndex - fireWidth) + column
            firePixelsArray[pixelIndex] = intensity
        }
    }
    
    @objc func calculateFirePropagation() {
        for column in 0..<fireWidth {
            for row in 0..<fireHeight {
                let pixelIndex = column + (fireWidth * row)
                updateFireIntensityPerPixel(currentPixelIndex: pixelIndex)
            }
        }
        renderFire()
    }
    
    func updateFireIntensityPerPixel(currentPixelIndex: Int){
        let belowPixelIndex = currentPixelIndex + fireWidth
        
        if belowPixelIndex >= fireWidth * fireHeight {
            return
        }
        
        let decay = Int(floor(Double.random(in: 0...1) * 3))
        let belowFireIntensity = firePixelsArray[belowPixelIndex]
        let newFireIntensity = belowFireIntensity - decay >= 0 ? belowFireIntensity - decay : 0
        
        switch windDirection {
        case 0:
            if (currentPixelIndex - decay >= 0){
                firePixelsArray[currentPixelIndex - decay] = newFireIntensity
            }
        case 1:
            firePixelsArray[currentPixelIndex] = newFireIntensity
        case 2:
            if ((currentPixelIndex + decay) < fireWidth * fireHeight){
                firePixelsArray[currentPixelIndex + decay] = newFireIntensity
            }
        default:
            break
        }
    }
    
    func renderFire() {
        fireCollectionView.reloadData()
    }
    
    //MARK: - Necessary CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fireWidth * fireHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let intensity = firePixelsArray[indexPath.row]
        cell.backgroundColor = colors[intensity]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 18, height: 18)
    }
}

