import UIKit

class CustomScrollView: UIScrollView, UIScrollViewDelegate {

    let fadePercentage: Double = 0.2
    let gradientLayer = CAGradientLayer()
    let transparentColor = UIColor.clear.cgColor
    let opaqueColor = UIColor.black.cgColor

    var topOpacity: CGColor {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y

        let alpha: CGFloat = (scrollViewHeight >= scrollContentSizeHeight || scrollOffset <= 0) ? 1 : 0

        let color = UIColor(white: 0, alpha: alpha)
        return color.cgColor
    }

    var bottomOpacity: CGColor {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y

        let alpha: CGFloat = (scrollViewHeight >= scrollContentSizeHeight ||
            scrollOffset + scrollViewHeight >= scrollContentSizeHeight) ? 1 : 0

        let color = UIColor(white: 0, alpha: alpha)
        return color.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.delegate = self
        let maskLayer = CALayer()
        maskLayer.frame = self.bounds

        gradientLayer.frame = CGRect(x: self.bounds.origin.x,
                                     y: 0, width: self.bounds.size.width,
                                     height: self.bounds.size.height)
        gradientLayer.colors = [topOpacity, opaqueColor, opaqueColor, bottomOpacity]
        
        //swiftlint:disable:next compiler_protocol_init
        gradientLayer.locations = [0, NSNumber(floatLiteral: fadePercentage),
                                   NSNumber(floatLiteral: 1 - fadePercentage), 1]
        //swiftlint:disable:previous compiler_protocol_init
        
        maskLayer.addSublayer(gradientLayer)

        self.layer.mask = maskLayer
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        gradientLayer.colors = [topOpacity, opaqueColor, opaqueColor, bottomOpacity]
    }
}
