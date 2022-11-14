//
//  ViewController.swift
//  Project27
//
//  Created by Oliwier Kasprzak on 06/11/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        drawRectangle()
    }
    
    
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        switch currentDrawType {
        case 0:
            drawSomething()
        case 1:
            drawSomething()
        case 2:
            drawCheckboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        case 7:
            drawSomething()
        default:
            break
        }
    }
    
    func drawRectangle() {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = render.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.blue.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        imageView.image = image
    }
    func drawCircle() {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = render.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.blue.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        imageView.image = image
    }
    func drawCheckboard() {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = render.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col).isMultiple(of: 2) {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
            }
        imageView.image = image
    }
    func drawRotatedSquares() {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = render.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let ammount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(ammount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = image
    }
    func drawLines() {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = render.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            ctx.cgContext.setStrokeColor(UIColor.blue.cgColor)
            ctx.cgContext.strokePath()
        }
            imageView.image = image
        
    }
    
    func drawImagesAndText() {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = render.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448),options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        imageView.image = image
    }
    func drawEmoji() {
           let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
           
           let image = renderer.image { ctx in
               ctx.cgContext.translateBy(x: 192, y: 192)
               
               // chosen emoji 😀
               // Step 1: draw the contour
               let ellipseSize: CGFloat = 128
               let rectangle = CGRect(x: 0, y: 0, width: ellipseSize, height: ellipseSize)
               
               ctx.cgContext.setFillColor(UIColor.init(displayP3Red: 248 / 255, green: 213 / 255, blue: 84 / 255, alpha: 1).cgColor)
               
               ctx.cgContext.addEllipse(in: rectangle)
               ctx.cgContext.drawPath(using: .fillStroke)
               
               // Step 2: create two rectangles to hold the eyes ellipses
               let eyesY: CGFloat = ellipseSize / 4
               let eyesWidth: CGFloat = 10
               let eyesHeight: CGFloat = 20
               let eyesRectangleLeft = CGRect(x: (ellipseSize / 2) - (15 + eyesWidth), y: eyesY, width: eyesWidth, height: eyesHeight)
               let eyesRectangleRight = CGRect(x: (ellipseSize / 2) + 15, y: eyesY, width: 10, height: 20)
               
               ctx.cgContext.setFillColor(UIColor.init(displayP3Red: 101 / 255, green: 56 / 255, blue: 18 / 255, alpha: 1).cgColor)
               
               ctx.cgContext.addEllipse(in: eyesRectangleLeft)
               ctx.cgContext.addEllipse(in: eyesRectangleRight)
               ctx.cgContext.drawPath(using: .fillStroke)
               
               // at this point we are here: 😶, not bad at all! Now how to get to the smile?
               ctx.cgContext.beginPath()
               
               let smileX: CGFloat = 24
               let smileY: CGFloat = 86
               ctx.cgContext.move(to: CGPoint(x: smileX, y: smileY))
               
               ctx.cgContext.addQuadCurve(to: CGPoint(x: smileX + 80, y: smileY), control: CGPoint(x: 64, y: smileY + 45))
               ctx.cgContext.closePath()
               ctx.cgContext.setFillColor(UIColor.init(displayP3Red: 158/255, green: 106/255, blue: 37/155, alpha: 1).cgColor)
               ctx.cgContext.drawPath(using: .fillStroke)
           }
           
           imageView.image = image
       }
    
    func drawSomething() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
               
               let image = renderer.image { ctx in
                   ctx.cgContext.translateBy(x: 138, y: 206) // draw from the center of the canvas
                   
                   let margin: CGFloat = 6
                   
                   // T
                   let widthT: CGFloat = 60
                   ctx.cgContext.move(to: CGPoint(x: margin, y: 0))
                   ctx.cgContext.addLine(to: CGPoint(x: widthT + margin, y: 0)) // draw the upper line of the T
                   
                   ctx.cgContext.move(to: CGPoint(x: margin + (widthT / 2), y: 0))
                   ctx.cgContext.addLine(to: CGPoint(x: margin + (widthT / 2), y: 100)) // draw the stem of the T
                   
                   // leave some space between T and W
                   let firstSpace: CGFloat = 10
                   let endXofT: CGFloat = margin + widthT
                   let wavesWidth: CGFloat = 17.5
                   let startOfW: CGFloat = endXofT + firstSpace
                   let wCentralHeight: CGFloat = 30
                   
                   // W
                   ctx.cgContext.move(to: CGPoint(x: startOfW, y: 0))
                   ctx.cgContext.addLine(to: CGPoint(x: startOfW + wavesWidth, y: 100))
                   ctx.cgContext.addLine(to: CGPoint(x: startOfW + (2 * wavesWidth), y: wCentralHeight))
                   ctx.cgContext.addLine(to: CGPoint(x: startOfW + (3 * wavesWidth), y: 100))
                   ctx.cgContext.addLine(to: CGPoint(x: startOfW + (4 * wavesWidth), y: 0))
                   let endXofW: CGFloat = startOfW + (wavesWidth * 4)
                   
                   // configure beginning of I
                   let secondSpace: CGFloat = 20
                   let startXofI: CGFloat = endXofW + secondSpace
                   
                   // I
                   ctx.cgContext.move(to: CGPoint(x: startXofI, y: 0))
                   ctx.cgContext.addLine(to: CGPoint(x: startXofI, y: 100))
                   let endXofI: CGFloat = startXofI
                   
                   // configure beginning of N
                   let thirdSpace: CGFloat = 20 // possibly = secondSpace, to verify
                   let startXofN: CGFloat = endXofI + thirdSpace
                   
                   // N
                   ctx.cgContext.move(to: CGPoint(x: startXofN, y: 100))
                   ctx.cgContext.addLine(to: CGPoint(x: startXofN, y: 0))
                   let widthN: CGFloat = 55
                   ctx.cgContext.addLine(to: CGPoint(x: startXofN + widthN, y: 100))
                   ctx.cgContext.addLine(to: CGPoint(x: startXofN + widthN, y: 0))

       //            ctx.cgContext.setLineWidth(<#T##width: CGFloat##CGFloat#>)
                   ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
                   ctx.cgContext.strokePath()
               }
               
               imageView.image = image
           }
    }


