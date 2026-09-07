import SwiftUI

struct AppColorToken: ShapeStyle {
    let resource: ColorResource

    var color: Color { Color(resource) }
    var uiColor: UIColor { UIColor(resource: resource) }

    func resolve(in environment: EnvironmentValues) -> Color { color }
}
