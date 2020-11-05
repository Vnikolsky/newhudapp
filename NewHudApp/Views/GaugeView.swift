//
//  GaugeView.swift
//  NewHudApp
//
//  Created by Владислав Никольский on 04.11.2020.
//  Copyright © 2020 Владислав Никольский. All rights reserved.
//

import UIKit

@IBDesignable

class GaugeView: UIView {

    var outerBezelColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
    var outerBezelWidth: CGFloat = 10

    var innerBezelColor = UIColor.white
    var innerBezelWidth: CGFloat = 5

    var insideColor = UIColor.darkGray

    
    var segmentWidth: CGFloat = 20
       var segmentColors = [UIColor(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), UIColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), UIColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), UIColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), UIColor(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1))]
    
    var totalAngle: CGFloat = 270
    var rotation: CGFloat = -135
    
    
    var majorTickColor = UIColor.black
    var majorTickWidth: CGFloat = 2
    var majorTickLength: CGFloat = 25

    var minorTickColor = UIColor.black.withAlphaComponent(0.5)
    var minorTickWidth: CGFloat = 1
    var minorTickLength: CGFloat = 20
    var minorTickCount = 3
    
    var outerCenterDiscColor = UIColor(white: 0.9, alpha: 1)
    var outerCenterDiscWidth: CGFloat = 35
    var innerCenterDiscColor = UIColor(white: 0.7, alpha: 1)
    var innerCenterDiscWidth: CGFloat = 25
    
    var needleColor = UIColor(white: 0.7, alpha: 1)
    var needleWidth: CGFloat = 4
    let needle = UIView()
    
    let valueLabel = UILabel()
    var valueFont = UIFont.systemFont(ofSize: 45)
    var valueColor = UIColor.white
    
    let gaugeUnitsLabel = UILabel()
    var gaugeUnitsLabelFont = UIFont.systemFont(ofSize: 19)
    var gaugeUnitsLabelColor = UIColor.white
    
    var value: Int = 0 {
        didSet {
            
            valueLabel.text = String(value)

            
            let needlePosition = CGFloat(value) / 100

            
            let lerpFrom = rotation
            let lerpTo = rotation + totalAngle

            
            let needleRotation = lerpFrom + (lerpTo - lerpFrom) * needlePosition
            needle.transform = CGAffineTransform(rotationAngle: deg2rad(needleRotation))
        }
    }
    
    override init(frame: CGRect) {
               super.init(frame: frame)
               setUp()
           }

           required init?(coder aDecoder: NSCoder) {
               super.init(coder: aDecoder)
               setUp()
           }
    
    func drawBackground(in rect: CGRect, context ctx: CGContext) {
        
        outerBezelColor.set()
        ctx.fillEllipse(in: rect)

        
        let innerBezelRect = rect.insetBy(dx: outerBezelWidth, dy: outerBezelWidth)
        innerBezelColor.set()
        ctx.fillEllipse(in: innerBezelRect)

        
        let insideRect = innerBezelRect.insetBy(dx: innerBezelWidth, dy: innerBezelWidth)
        insideColor.set()
        ctx.fillEllipse(in: insideRect)
    }
    
    
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        drawBackground(in: rect, context: ctx)
        drawSegments(in: rect, context: ctx)
        drawTicks(in: rect, context: ctx)
        drawCenterDisc(in: rect, context: ctx)
        setUp()
    }
    
    
   func deg2rad(_ number: CGFloat) -> CGFloat {
       return number * .pi / 180
   }
    
    
   func drawSegments(in rect: CGRect, context ctx: CGContext) {
        
        ctx.saveGState()

        
        ctx.translateBy(x: rect.midX, y: rect.midY)
        ctx.rotate(by: deg2rad(rotation) - (.pi / 2))

        
        ctx.setLineWidth(segmentWidth)

        
        let segmentAngle = deg2rad(totalAngle / CGFloat(segmentColors.count))

        
        let segmentRadius = (((rect.width - segmentWidth) / 2) - outerBezelWidth) - innerBezelWidth

        
        for (index, segment) in segmentColors.enumerated() {
            
            let start = CGFloat(index) * segmentAngle

            
            segment.set()

            
            ctx.addArc(center: .zero, radius: segmentRadius, startAngle: start, endAngle: start + segmentAngle, clockwise: false)

            
            ctx.drawPath(using: .stroke)
        }

        
        ctx.restoreGState()
    }
    
    func drawTicks(in rect: CGRect, context ctx: CGContext) {
        
        ctx.saveGState()
        ctx.translateBy(x: rect.midX, y: rect.midY)
        ctx.rotate(by: deg2rad(rotation) - (.pi / 2))

        let segmentAngle = deg2rad(totalAngle / CGFloat(segmentColors.count))

        let segmentRadius = (((rect.width - segmentWidth) / 2) - outerBezelWidth) - innerBezelWidth

        
        ctx.saveGState()

        ctx.setLineWidth(majorTickWidth)
        majorTickColor.set()
        
        let majorEnd = segmentRadius + (segmentWidth / 2)
        let majorStart = majorEnd - majorTickLength
        
        for _ in 0 ... segmentColors.count {
            ctx.move(to: CGPoint(x: majorStart, y: 0))
            ctx.addLine(to: CGPoint(x: majorEnd, y: 0))
            ctx.drawPath(using: .stroke)
            ctx.rotate(by: segmentAngle)
        }

        
        ctx.restoreGState()

        
        ctx.saveGState()

        ctx.setLineWidth(minorTickWidth)
        minorTickColor.set()

        let minorEnd = segmentRadius + (segmentWidth / 2)
        let minorStart = minorEnd - minorTickLength
        
        let minorTickSize = segmentAngle / CGFloat(minorTickCount + 1)
        
        for _ in 0 ..< segmentColors.count {
            ctx.rotate(by: minorTickSize)

            for _ in 0 ..< minorTickCount {
                ctx.move(to: CGPoint(x: minorStart, y: 0))
                ctx.addLine(to: CGPoint(x: minorEnd, y: 0))
                ctx.drawPath(using: .stroke)
                ctx.rotate(by: minorTickSize)
            }
        }

        
        ctx.restoreGState()

       
        ctx.restoreGState()
    }
    
    func drawCenterDisc(in rect: CGRect, context ctx: CGContext) {
        ctx.saveGState()
        ctx.translateBy(x: rect.midX, y: rect.midY)

        let outerCenterRect = CGRect(x: -outerCenterDiscWidth / 2, y: -outerCenterDiscWidth / 2, width: outerCenterDiscWidth, height: outerCenterDiscWidth)
        outerCenterDiscColor.set()
        ctx.fillEllipse(in: outerCenterRect)

        let innerCenterRect = CGRect(x: -innerCenterDiscWidth / 2, y: -innerCenterDiscWidth / 2, width: innerCenterDiscWidth, height: innerCenterDiscWidth)
        innerCenterDiscColor.set()
        ctx.fillEllipse(in: innerCenterRect)
        ctx.restoreGState()
    }
    
    
    func setUp() {
        needle.backgroundColor = needleColor
        needle.translatesAutoresizingMaskIntoConstraints = false

        
        needle.bounds = CGRect(x: 0, y: 0, width: needleWidth, height: bounds.height / 3)

        
        needle.layer.anchorPoint = CGPoint(x: 0.5, y: 1)

        
        needle.center = CGPoint(x: bounds.midX, y: bounds.midY)
        addSubview(needle)
        
        valueLabel.font = valueFont
        valueLabel.text = "0"
        valueLabel.textColor = valueColor
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        
        gaugeUnitsLabel.font = gaugeUnitsLabelFont
        gaugeUnitsLabel.text = "km/h"
        gaugeUnitsLabel.textColor = gaugeUnitsLabelColor
        gaugeUnitsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gaugeUnitsLabel)

        NSLayoutConstraint.activate([
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            gaugeUnitsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            gaugeUnitsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
       
    }
    
    
    
}
