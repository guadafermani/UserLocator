import UIKit

extension UIImage {
    func pixelColor(at point: CGPoint) -> UIColor? {
        var pixel: [UInt8] = [0, 0, 0, 0]

        guard let cgImage,
              let context = CGContext(
                data: &pixel,
                width: 1,
                height: 1,
                bitsPerComponent: 8,
                bytesPerRow: 4,
                space: CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
              ) else { return nil }

        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        context.interpolationQuality = .none
        context.draw(
            cgImage,
            in: CGRect(
                x: -point.x * scale,
                y: -(height - point.y * scale - 1),
                width: width,
                height: height
            )
        )

        return UIColor(premultiplied: pixel)
    }
}

private extension UIColor {
    convenience init(premultiplied pixel: [UInt8]) {
        let alpha = CGFloat(pixel[3]) / 255
        let component = { (value: UInt8) in alpha > 0 ? CGFloat(value) / 255 / alpha : 0 }

        self.init(
            red: component(pixel[0]),
            green: component(pixel[1]),
            blue: component(pixel[2]),
            alpha: alpha
        )
    }
}
