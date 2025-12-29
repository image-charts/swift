import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(CommonCrypto)
import CommonCrypto
#elseif canImport(Crypto)
import Crypto
#endif

/// Error types for ImageCharts API
public enum ImageChartsError: Error, LocalizedError {
    case invalidURL
    case httpError(statusCode: Int, message: String)
    case validationError(String)
    case networkError(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .httpError(let statusCode, let message):
            return "HTTP \(statusCode): \(message)"
        case .validationError(let message):
            return message
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}

/// Image-Charts URL builder and API client
/// A Swift client for image-charts.com, a web service that generates static charts.
public final class ImageCharts {
    private static let defaultEncoding = "UTF-8"
    private static let libraryVersion = "1.0.0"

    private var secret: String?
    private var timeout: TimeInterval = 5
    private var host: String = "image-charts.com"
    private var `protocol`: String = "https"
    private var port: Int = 443
    private var pathname: String = "/chart"
    private var userAgent: String?
    private var query: [String: String] = [:]

    /// Free usage
    public init() {}

    /// Enterprise & Enterprise+
    /// - Parameter secret: (Enterprise and Enterprise+ subscription only) SECRET_KEY
    public init(secret: String?) {
        self.secret = secret
    }

    /// Enterprise & Enterprise+
    /// - Parameters:
    ///   - secret: (Enterprise and Enterprise+ subscription only) SECRET_KEY
    ///   - timeout: Request timeout (in seconds) when calling toData() or toDataURI()
    public init(secret: String?, timeout: TimeInterval?) {
        self.secret = secret
        if let timeout = timeout { self.timeout = timeout }
    }

    /// On-premise configuration
    /// - Parameters:
    ///   - protocol: (On-Premise subscription only) custom protocol. Default: "https"
    ///   - host: (Enterprise, Enterprise+ and On-Premise subscription only) custom domain. Default: "image-charts.com"
    ///   - port: (On-Premise subscription only) custom port. Default: 443
    ///   - pathname: (On-Premise subscription only) custom pathname. Default: "/chart"
    ///   - secret: (Enterprise and Enterprise+ subscription only) SECRET_KEY
    public init(`protocol`: String?, host: String?, port: Int?, pathname: String?, secret: String?) {
        if let `protocol` = `protocol` { self.protocol = `protocol` }
        if let host = host { self.host = host }
        if let port = port { self.port = port }
        if let pathname = pathname { self.pathname = pathname }
        self.secret = secret
    }

    /// Full constructor with all options
    /// - Parameters:
    ///   - protocol: (On-Premise subscription only) custom protocol. Default: "https"
    ///   - host: (Enterprise, Enterprise+ and On-Premise subscription only) custom domain. Default: "image-charts.com"
    ///   - port: (On-Premise subscription only) custom port. Default: 443
    ///   - pathname: (On-Premise subscription only) custom pathname. Default: "/chart"
    ///   - secret: (Enterprise and Enterprise+ subscription only) SECRET_KEY
    ///   - timeout: Request timeout (in seconds) when calling toData() or toDataURI()
    ///   - userAgent: Custom user-agent string
    public init(`protocol`: String?, host: String?, port: Int?, pathname: String?, secret: String?, timeout: TimeInterval?, userAgent: String?) {
        if let `protocol` = `protocol` { self.protocol = `protocol` }
        if let host = host { self.host = host }
        if let port = port { self.port = port }
        if let pathname = pathname { self.pathname = pathname }
        self.secret = secret
        if let timeout = timeout { self.timeout = timeout }
        self.userAgent = userAgent
    }

    private init(copyFrom source: ImageCharts) {
        self.secret = source.secret
        self.timeout = source.timeout
        self.host = source.host
        self.protocol = source.protocol
        self.port = source.port
        self.pathname = source.pathname
        self.userAgent = source.userAgent
        self.query = source.query
    }

    private func clone(key: String, value: String) -> ImageCharts {
        let copy = ImageCharts(copyFrom: self)
        copy.query[key] = value
        return copy
    }

    // MARK: - Chart Configuration Methods

    /// bvg= grouped bar chart, bvs= stacked bar chart, lc=line chart, ls=sparklines, p=pie chart. gv=graph viz         Three-dimensional pie chart (p3) will be rendered in 2D, concentric pie chart are not supported.         [Optional, line charts only] You can add :nda after the chart type in line charts to hide the default axes.
    /// - Parameter value: The value for cht
    /// - Returns: A new ImageCharts instance with the parameter set
    public func cht(_ value: String) -> ImageCharts {
        return self.clone(key: "cht", value: value)
    }

    /// chart data
    /// - Parameter value: The value for chd
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chd(_ value: String) -> ImageCharts {
        return self.clone(key: "chd", value: value)
    }

    /// You can configure some charts to scale automatically to fit their data with chds=a. The chart will be scaled so that the largest value is at the top of the chart and the smallest (or zero, if all values are greater than zero) will be at the bottom. Otherwise the &#39;&amp;lg;series_1_min),&amp;lg;series_1_max),...,&amp;lg;series_n_min),&amp;lg;series_n_max)&#39; format set one or more minimum and maximum permitted values for each data series, separated by commas. You must supply both a max and a min. If you supply fewer pairs than there are data series, the last pair is applied to all remaining data series. Note that this does not change the axis range; to change the axis range, you must set the chxr parameter. Valid values range from (+/-)9.999e(+/-)199. You can specify values in either standard or E notation.
    /// - Parameter value: The value for chds
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chds(_ value: String) -> ImageCharts {
        return self.clone(key: "chds", value: value)
    }

    /// How to encode the data in the QR code. &#39;UTF-8&#39; is the default and only supported value. Contact our team if you wish to have support for Shift_JIS and/or ISO-8859-1.
    /// - Parameter value: The value for choe
    /// - Returns: A new ImageCharts instance with the parameter set
    public func choe(_ value: String) -> ImageCharts {
        return self.clone(key: "choe", value: value)
    }

    /// QRCode error correction level and optional margin Default: &#34;L|4&#34;
    /// - Parameter value: The value for chld
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chld(_ value: String) -> ImageCharts {
        return self.clone(key: "chld", value: value)
    }

    /// You can specify the range of values that appear on each axis independently, using the chxr parameter. Note that this does not change the scale of the chart elements (use chds for that), only the scale of the axis labels.
    /// - Parameter value: The value for chxr
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chxr(_ value: String) -> ImageCharts {
        return self.clone(key: "chxr", value: value)
    }

    /// Some clients like Flowdock/Facebook messenger and so on, needs an URL to ends with a valid image extension file to display the image, use this parameter at the end your URL to support them. Valid values are &#39;.png&#39;, &#39;.svg&#39; and &#39;.gif&#39;.           Only QRCodes and GraphViz support svg output. Default: &#34;.png&#34;
    /// - Parameter value: The value for chof
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chof(_ value: String) -> ImageCharts {
        return self.clone(key: "chof", value: value)
    }

    /// Maximum chart size for all charts except maps is 998,001 pixels total (Google Image Charts was limited to 300,000), and maximum width or length is 999 pixels.
    /// - Parameter value: The value for chs
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chs(_ value: String) -> ImageCharts {
        return self.clone(key: "chs", value: value)
    }

    /// Format: (data_series_1_label) or ... or (data_series_n_label). The text for the legend entries. Each label applies to the corresponding series in the chd array. Use a + mark for a space. If you do not specify this parameter, the chart will not get a legend. There is no way to specify a line break in a label. The legend will typically expand to hold your legend text, and the chart area will shrink to accommodate the legend.
    /// - Parameter value: The value for chdl
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chdl(_ value: String) -> ImageCharts {
        return self.clone(key: "chdl", value: value)
    }

    /// Specifies the color and font size of the legend text. (color),(size) Default: &#34;000000&#34;
    /// - Parameter value: The value for chdls
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chdls(_ value: String) -> ImageCharts {
        return self.clone(key: "chdls", value: value)
    }

    /// Solid or dotted grid lines
    /// - Parameter value: The value for chg
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chg(_ value: String) -> ImageCharts {
        return self.clone(key: "chg", value: value)
    }

    /// You can specify the colors of a specific series using the chco parameter.       Format should be (series_2),...,(series_m), with each color in RRGGBB format hexadecimal number.       The exact syntax and meaning can vary by chart type; see your specific chart type for details.       Each entry in this string is an RRGGBB[AA] format hexadecimal number.       If there are more series or elements in the chart than colors specified in your string, the API typically cycles through element colors from the start of that series (for elements) or for series colors from the start of the series list.       Again, see individual chart documentation for details. Default: &#34;F56991,FF9F80,FFC48C,D1F2A5,EFFAB4&#34;
    /// - Parameter value: The value for chco
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chco(_ value: String) -> ImageCharts {
        return self.clone(key: "chco", value: value)
    }

    /// chart title
    /// - Parameter value: The value for chtt
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chtt(_ value: String) -> ImageCharts {
        return self.clone(key: "chtt", value: value)
    }

    /// Format should be &#39;(color),(font_size)[,(opt_alignment),(opt_font_family),(opt_font_style)]&#39;, opt_alignement is not supported
    /// - Parameter value: The value for chts
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chts(_ value: String) -> ImageCharts {
        return self.clone(key: "chts", value: value)
    }

    /// Specify which axes you want (from: &#39;x&#39;, &#39;y&#39;, &#39;t&#39; and &#39;r&#39;). You can use several of them, separated by a coma; for example: &#39;x,x,y,r&#39;. Order is important.
    /// - Parameter value: The value for chxt
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chxt(_ value: String) -> ImageCharts {
        return self.clone(key: "chxt", value: value)
    }

    /// Specify one parameter set for each axis that you want to label. Format &#39;(axis_index): or (label_1) or ... or (label_n) or ... or (axis_index): or (label_1) or ... or (label_n)&#39;. Separate multiple sets of labels using the pipe character (  or  ).
    /// - Parameter value: The value for chxl
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chxl(_ value: String) -> ImageCharts {
        return self.clone(key: "chxl", value: value)
    }

    /// You can specify the range of values that appear on each axis independently, using the chxr parameter. Note that this does not change the scale of the chart elements (use chds for that), only the scale of the axis labels.
    /// - Parameter value: The value for chxs
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chxs(_ value: String) -> ImageCharts {
        return self.clone(key: "chxs", value: value)
    }

    /// format should be either:   - line fills (fill the area below a data line with a solid color): chm=(b_or_B),(color),(start_line_index),(end_line_index),(0)  or ... or  (b_or_B),(color),(start_line_index),(end_line_index),(0)   - line marker (add a line that traces data in your chart): chm=D,(color),(series_index),(which_points),(width),(opt_z_order)   - Text and Data Value Markers: chm=N(formatting_string),(color),(series_index),(which_points),(width),(opt_z_order),(font_family),(font_style)
    /// - Parameter value: The value for chm
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chm(_ value: String) -> ImageCharts {
        return self.clone(key: "chm", value: value)
    }

    /// line thickness and solid/dashed style
    /// - Parameter value: The value for chls
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chls(_ value: String) -> ImageCharts {
        return self.clone(key: "chls", value: value)
    }

    /// If specified it will override &#39;chdl&#39; values
    /// - Parameter value: The value for chl
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chl(_ value: String) -> ImageCharts {
        return self.clone(key: "chl", value: value)
    }

    /// Position and style of labels on data
    /// - Parameter value: The value for chlps
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chlps(_ value: String) -> ImageCharts {
        return self.clone(key: "chlps", value: value)
    }

    /// chart margins
    /// - Parameter value: The value for chma
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chma(_ value: String) -> ImageCharts {
        return self.clone(key: "chma", value: value)
    }

    /// Position of the legend and order of the legend entries Default: &#34;r&#34;
    /// - Parameter value: The value for chdlp
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chdlp(_ value: String) -> ImageCharts {
        return self.clone(key: "chdlp", value: value)
    }

    /// Background Fills Default: &#34;bg,s,FFFFFF&#34;
    /// - Parameter value: The value for chf
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chf(_ value: String) -> ImageCharts {
        return self.clone(key: "chf", value: value)
    }

    /// Bar corner radius. Display bars with rounded corner.
    /// - Parameter value: The value for chbr
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chbr(_ value: String) -> ImageCharts {
        return self.clone(key: "chbr", value: value)
    }

    /// gif configuration
    /// - Parameter value: The value for chan
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chan(_ value: String) -> ImageCharts {
        return self.clone(key: "chan", value: value)
    }

    /// doughnut chart inside label
    /// - Parameter value: The value for chli
    /// - Returns: A new ImageCharts instance with the parameter set
    public func chli(_ value: String) -> ImageCharts {
        return self.clone(key: "chli", value: value)
    }

    /// image-charts enterprise `account_id`
    /// - Parameter value: The value for icac
    /// - Returns: A new ImageCharts instance with the parameter set
    public func icac(_ value: String) -> ImageCharts {
        return self.clone(key: "icac", value: value)
    }

    /// HMAC-SHA256 signature required to activate paid features
    /// - Parameter value: The value for ichm
    /// - Returns: A new ImageCharts instance with the parameter set
    public func ichm(_ value: String) -> ImageCharts {
        return self.clone(key: "ichm", value: value)
    }

    /// How to use icff to define font family as Google Font : https://developers.google.com/fonts/docs/css2
    /// - Parameter value: The value for icff
    /// - Returns: A new ImageCharts instance with the parameter set
    public func icff(_ value: String) -> ImageCharts {
        return self.clone(key: "icff", value: value)
    }

    /// Default font style for all text
    /// - Parameter value: The value for icfs
    /// - Returns: A new ImageCharts instance with the parameter set
    public func icfs(_ value: String) -> ImageCharts {
        return self.clone(key: "icfs", value: value)
    }

    /// localization (ISO 639-1)
    /// - Parameter value: The value for iclocale
    /// - Returns: A new ImageCharts instance with the parameter set
    public func iclocale(_ value: String) -> ImageCharts {
        return self.clone(key: "iclocale", value: value)
    }

    /// Retina is a marketing term coined by Apple that refers to devices and monitors that have a resolution and pixel density so high — roughly 300 or more pixels per inch – that a person is unable to discern the individual pixels at a normal viewing distance.           In order to generate beautiful charts for these Retina displays, Image-Charts supports a retina mode that can be activated through the icretina=1 parameter
    /// - Parameter value: The value for icretina
    /// - Returns: A new ImageCharts instance with the parameter set
    public func icretina(_ value: String) -> ImageCharts {
        return self.clone(key: "icretina", value: value)
    }

    /// Background color for QR Codes Default: &#34;FFFFFF&#34;
    /// - Parameter value: The value for icqrb
    /// - Returns: A new ImageCharts instance with the parameter set
    public func icqrb(_ value: String) -> ImageCharts {
        return self.clone(key: "icqrb", value: value)
    }

    /// Foreground color for QR Codes Default: &#34;000000&#34;
    /// - Parameter value: The value for icqrf
    /// - Returns: A new ImageCharts instance with the parameter set
    public func icqrf(_ value: String) -> ImageCharts {
        return self.clone(key: "icqrf", value: value)
    }


    /// Get the full Image-Charts API url (signed and encoded if necessary)
    /// - Returns: The full generated URL string
    public func toURL() -> String {
        var components = URLComponents()
        components.scheme = self.protocol
        components.host = self.host
        components.port = self.port == 443 ? nil : self.port
        components.path = self.pathname

        var queryItems = self.query.map { URLQueryItem(name: $0.key, value: $0.value) }

        // Sort query items for consistent ordering
        queryItems.sort { $0.name < $1.name }

        if let icac = self.query["icac"], let secret = self.secret, !secret.isEmpty {
            // Build the query string for signing
            let queryString = queryItems
                .map { "\($0.name)=\(($0.value ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
                .joined(separator: "&")

            let signature = Self.hmacSHA256(key: secret, data: queryString)
            queryItems.append(URLQueryItem(name: "ichm", value: signature))
        }

        components.queryItems = queryItems

        return components.url?.absoluteString ?? ""
    }

    /// Do a request to Image-Charts API with current configuration and yield image data
    /// - Parameter completion: Completion handler with Result containing Data or ImageChartsError
    public func toData(completion: @escaping (Result<Data, ImageChartsError>) -> Void) {
        guard let url = URL(string: self.toURL()) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = self.timeout

        let userAccount = self.query["icac"].map { " (\($0))" } ?? ""
        let effectiveUserAgent = self.userAgent ?? "swift-image-charts/\(Self.libraryVersion)\(userAccount)"
        request.setValue(effectiveUserAgent, forHTTPHeaderField: "User-Agent")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.networkError(NSError(domain: "ImageCharts", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))))
                return
            }

            let statusCode = httpResponse.statusCode

            if statusCode >= 200 && statusCode < 300 {
                guard let data = data else {
                    completion(.failure(.httpError(statusCode: statusCode, message: "No data received")))
                    return
                }
                completion(.success(data))
                return
            }

            let validationMessage = httpResponse.value(forHTTPHeaderField: "x-ic-error-validation")
            let validationCode = httpResponse.value(forHTTPHeaderField: "x-ic-error-code") ?? "HTTP_\(statusCode)"
            var message = ""

            if let validationMessage = validationMessage, !validationMessage.isEmpty {
                if let jsonData = validationMessage.data(using: .utf8),
                   let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] {
                    let messages = jsonArray.compactMap { $0["message"] as? String }
                    message = messages.joined(separator: "\n")
                }
            }

            message = message.isEmpty ? validationCode : message
            completion(.failure(.validationError(message)))
        }

        task.resume()
    }

    /// Do a request to Image-Charts API with current configuration and yield image data (async/await)
    /// - Returns: The image data
    /// - Throws: ImageChartsError if the request fails
    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    public func toData() async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            self.toData { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// Do a request to Image-Charts API with current configuration and write the content to a file
    /// - Parameters:
    ///   - path: The file path to write to
    ///   - completion: Completion handler with Result containing Void or ImageChartsError
    public func toFile(_ path: String, completion: @escaping (Result<Void, ImageChartsError>) -> Void) {
        self.toData { result in
            switch result {
            case .success(let data):
                do {
                    try data.write(to: URL(fileURLWithPath: path))
                    completion(.success(()))
                } catch {
                    completion(.failure(.networkError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Do a request to Image-Charts API with current configuration and write the content to a file (async/await)
    /// - Parameter path: The file path to write to
    /// - Throws: ImageChartsError if the request or file write fails
    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    public func toFile(_ path: String) async throws {
        let data = try await self.toData()
        try data.write(to: URL(fileURLWithPath: path))
    }

    /// Do a request to Image-Charts API with current configuration and yield a base64 encoded data URI
    /// - Parameter completion: Completion handler with Result containing the data URI string or ImageChartsError
    public func toDataURI(completion: @escaping (Result<String, ImageChartsError>) -> Void) {
        self.toData { result in
            switch result {
            case .success(let data):
                let mimetype = self.query["chan"] != nil ? "image/gif" : "image/png"
                let base64 = data.base64EncodedString()
                let dataURI = "data:\(mimetype);base64,\(base64)"
                completion(.success(dataURI))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Do a request to Image-Charts API with current configuration and yield a base64 encoded data URI (async/await)
    /// - Returns: The base64 encoded data URI string
    /// - Throws: ImageChartsError if the request fails
    @available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
    public func toDataURI() async throws -> String {
        let data = try await self.toData()
        let mimetype = self.query["chan"] != nil ? "image/gif" : "image/png"
        let base64 = data.base64EncodedString()
        return "data:\(mimetype);base64,\(base64)"
    }

    // MARK: - Private Helpers

    private static func hmacSHA256(key: String, data: String) -> String {
        let keyData = Array(key.utf8)
        let dataBytes = Array(data.utf8)

#if canImport(CommonCrypto)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyData, keyData.count, dataBytes, dataBytes.count, &digest)
        return digest.map { String(format: "%02x", $0) }.joined()
#elseif canImport(Crypto)
        let key = SymmetricKey(data: Data(keyData))
        let signature = HMAC<SHA256>.authenticationCode(for: Data(dataBytes), using: key)
        return Data(signature).map { String(format: "%02x", $0) }.joined()
#else
        // Fallback: simple implementation for platforms without crypto support
        fatalError("No crypto library available for HMAC-SHA256")
#endif
    }
}
