import XCTest

@available(iOS 9.0, *)
public extension XCTestCase {
    func saveScreenshot(to filename: String) {
        wait(1)
        let screenshot = XCUIScreen.main.screenshot()
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        
        let path = directory.appendingPathComponent("\(filename).jpg")
        try? screenshot.pngRepresentation.write(to: path)
        debugPrint("screenshot saved to: \(path)")
    }
}
