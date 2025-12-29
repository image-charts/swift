import XCTest
@testable import ImageCharts

final class ImageChartsTests: XCTestCase {

    // MARK: - Test Helpers

    func createImageCharts(_ options: [String: Any]? = nil) -> ImageCharts {
        if let userAgent = ProcessInfo.processInfo.environment["IMAGE_CHARTS_USER_AGENT"] {
            return ImageCharts(
                protocol: options?["protocol"] as? String,
                host: options?["host"] as? String,
                port: options?["port"] as? Int,
                pathname: options?["pathname"] as? String,
                secret: options?["secret"] as? String,
                timeout: options?["timeout"] as? TimeInterval,
                userAgent: userAgent
            )
        }
        return ImageCharts(
            protocol: options?["protocol"] as? String,
            host: options?["host"] as? String,
            port: options?["port"] as? Int,
            pathname: options?["pathname"] as? String,
            secret: options?["secret"] as? String,
            timeout: options?["timeout"] as? TimeInterval,
            userAgent: options?["userAgent"] as? String
        )
    }

    // MARK: - toURL Tests

    func testToURLReturnsValidURL() {
        let chart = ImageCharts()
            .cht("p")
            .chd("a:1,2,3")
            .chs("100x100")

        let url = chart.toURL()

        XCTAssertTrue(url.starts(with: "https://image-charts.com"))
        XCTAssertTrue(url.contains("cht=p"))
        XCTAssertTrue(url.contains("chs=100x100"))
    }

    func testToURLWithDefaultValues() {
        let url = ImageCharts().toURL()
        XCTAssertTrue(url.starts(with: "https://image-charts.com/chart"))
    }

    func testToURLWithCustomHost() {
        let chart = ImageCharts(protocol: nil, host: "custom-domain.tld", port: nil, pathname: nil, secret: nil)
            .cht("p")
            .chd("a:1,2,3")

        let url = chart.toURL()

        XCTAssertTrue(url.contains("custom-domain.tld"))
    }

    func testToURLWithCustomPort() {
        let chart = ImageCharts(protocol: "http", host: "localhost", port: 8080, pathname: "/chart", secret: nil)
            .cht("p")
            .chd("a:1,2,3")

        let url = chart.toURL()

        XCTAssertTrue(url.contains(":8080"))
    }

    func testToURLWithSignature() {
        let chart = ImageCharts(secret: "my-secret-key")
            .cht("p")
            .chd("a:1,2,3")
            .icac("my-account")

        let url = chart.toURL()

        XCTAssertTrue(url.contains("ichm="))
    }

    // MARK: - Parameter Chaining Tests
    
    func testChtParameter() {
        let chart = ImageCharts().cht("test-value")
        let url = chart.toURL()
        XCTAssertTrue(url.contains("cht="))
    }
    
    func testChdParameter() {
        let chart = ImageCharts().chd("test-value")
        let url = chart.toURL()
        XCTAssertTrue(url.contains("chd="))
    }
    
    func testChdsParameter() {
        let chart = ImageCharts().chds("test-value")
        let url = chart.toURL()
        XCTAssertTrue(url.contains("chds="))
    }
    
    func testChoeParameter() {
        let chart = ImageCharts().choe("test-value")
        let url = chart.toURL()
        XCTAssertTrue(url.contains("choe="))
    }
    
    func testChldParameter() {
        let chart = ImageCharts().chld("test-value")
        let url = chart.toURL()
        XCTAssertTrue(url.contains("chld="))
    }
    

    // MARK: - Immutability Tests

    func testChainingReturnsNewInstance() {
        let chart1 = ImageCharts().cht("p")
        let chart2 = chart1.chd("a:1,2,3")

        let url1 = chart1.toURL()
        let url2 = chart2.toURL()

        XCTAssertFalse(url1.contains("chd="))
        XCTAssertTrue(url2.contains("chd="))
    }

    // MARK: - toData Tests

    func testToDataReturnsData() {
        let expectation = XCTestExpectation(description: "Fetch chart data")

        let chart = createImageCharts()
            .cht("p")
            .chd("a:1,2,3")
            .chs("100x100")

        chart.toData { result in
            switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testToDataWithInvalidChartTypeReturnsError() {
        let expectation = XCTestExpectation(description: "Fetch chart data with error")

        let chart = createImageCharts()
            .cht("invalid-chart-type")
            .chd("a:1,2,3")

        chart.toData { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    // MARK: - toDataURI Tests

    func testToDataURIReturnsBase64DataURI() {
        let expectation = XCTestExpectation(description: "Fetch chart as data URI")

        let chart = createImageCharts()
            .cht("p")
            .chd("a:1,2,3")
            .chs("100x100")

        chart.toDataURI { result in
            switch result {
            case .success(let dataURI):
                XCTAssertTrue(dataURI.starts(with: "data:image/png;base64,"))
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testToDataURIWithAnimatedChartReturnsGifMimeType() {
        let expectation = XCTestExpectation(description: "Fetch animated chart as data URI")

        let chart = createImageCharts()
            .cht("p")
            .chd("a:1,2,3")
            .chs("100x100")
            .chan("1200")

        chart.toDataURI { result in
            switch result {
            case .success(let dataURI):
                XCTAssertTrue(dataURI.starts(with: "data:image/gif;base64,"))
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    // MARK: - Async/Await Tests (iOS 13+)

    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testToDataAsync() async throws {
        let chart = createImageCharts()
            .cht("p")
            .chd("a:1,2,3")
            .chs("100x100")

        let data = try await chart.toData()
        XCTAssertGreaterThan(data.count, 0)
    }

    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    func testToDataURIAsync() async throws {
        let chart = createImageCharts()
            .cht("p")
            .chd("a:1,2,3")
            .chs("100x100")

        let dataURI = try await chart.toDataURI()
        XCTAssertTrue(dataURI.starts(with: "data:image/png;base64,"))
    }

    // MARK: - HMAC Signature Tests

    func testSignatureIsConsistent() {
        let chart1 = ImageCharts(secret: "secret-key")
            .cht("p")
            .chd("a:1,2,3")
            .icac("account")

        let chart2 = ImageCharts(secret: "secret-key")
            .cht("p")
            .chd("a:1,2,3")
            .icac("account")

        XCTAssertEqual(chart1.toURL(), chart2.toURL())
    }

    func testDifferentSecretsProduceDifferentSignatures() {
        let chart1 = ImageCharts(secret: "secret-key-1")
            .cht("p")
            .chd("a:1,2,3")
            .icac("account")

        let chart2 = ImageCharts(secret: "secret-key-2")
            .cht("p")
            .chd("a:1,2,3")
            .icac("account")

        XCTAssertNotEqual(chart1.toURL(), chart2.toURL())
    }

    // MARK: - Custom User Agent Tests

    func testDefaultUserAgentIsUsed() {
        let chart = ImageCharts()
            .cht("p")
            .chd("a:1,2,3")

        // The user agent is set in the request, not the URL
        // This test just ensures no crash occurs
        let url = chart.toURL()
        XCTAssertFalse(url.isEmpty)
    }

    func testCustomUserAgentCanBeSet() {
        let chart = ImageCharts(protocol: nil, host: nil, port: nil, pathname: nil, secret: nil, timeout: nil, userAgent: "CustomAgent/1.0")
            .cht("p")
            .chd("a:1,2,3")

        // The user agent is set in the request, not the URL
        // This test just ensures no crash occurs
        let url = chart.toURL()
        XCTAssertFalse(url.isEmpty)
    }

    static var allTests = [
        ("testToURLReturnsValidURL", testToURLReturnsValidURL),
        ("testToURLWithDefaultValues", testToURLWithDefaultValues),
        ("testToURLWithCustomHost", testToURLWithCustomHost),
        ("testToURLWithCustomPort", testToURLWithCustomPort),
        ("testToURLWithSignature", testToURLWithSignature),
        ("testChainingReturnsNewInstance", testChainingReturnsNewInstance),
        ("testToDataReturnsData", testToDataReturnsData),
        ("testToDataWithInvalidChartTypeReturnsError", testToDataWithInvalidChartTypeReturnsError),
        ("testToDataURIReturnsBase64DataURI", testToDataURIReturnsBase64DataURI),
        ("testToDataURIWithAnimatedChartReturnsGifMimeType", testToDataURIWithAnimatedChartReturnsGifMimeType),
        ("testSignatureIsConsistent", testSignatureIsConsistent),
        ("testDifferentSecretsProduceDifferentSignatures", testDifferentSecretsProduceDifferentSignatures),
        ("testDefaultUserAgentIsUsed", testDefaultUserAgentIsUsed),
        ("testCustomUserAgentCanBeSet", testCustomUserAgentCanBeSet),
    ]
}
