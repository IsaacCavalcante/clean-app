import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        var redColor = red > 255 ? 255 : red
        redColor = red < 0 ? 0 : red
        
        var greenColor = green > 255 ? 255 : green
        greenColor = green < 0 ? 0 : green
        
        var blueColor = blue > 255 ? 255 : blue
        blueColor = blue < 0 ? 0 : blue
        
        self.init(red: CGFloat(redColor) / 255.0, green: CGFloat(greenColor) / 255.0, blue: CGFloat(blueColor) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
