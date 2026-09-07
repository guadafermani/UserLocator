import GoogleMaps
import Testing
@testable import UserLocator

@Suite("MapCamera")
struct MapCameraTests {

    @Test
    func whenBuildingTheInitialCamera_targetsTheCoordinate() {
        let coordinate = Coordinate(latitude: -37.3159, longitude: 81.1496)

        let camera = MapCamera.initial(at: coordinate)

        #expect(Coordinate(latitude: camera.target.latitude, longitude: camera.target.longitude) == coordinate)
    }

    @Test
    func whenBuildingTheInitialCamera_usesTheWorldZoom() {
        let camera = MapCamera.initial(at: .fixture())

        #expect(camera.zoom == 2)
    }

    @Test
    func whenBuildingTheInitialCamera_facesNorth() {
        let camera = MapCamera.initial(at: .fixture())

        #expect(camera.bearing == 0)
    }

    @Test
    func whenBuildingTheInitialCamera_hasNoTilt() {
        let camera = MapCamera.initial(at: .fixture())

        #expect(camera.viewingAngle == 0)
    }
}
