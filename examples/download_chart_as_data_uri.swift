import ImageCharts

let chart = ImageCharts()
    .cht("bvg") // vertical bar chart
    .chs("300x300") // 300px x 300px
    .chd("a:60,40") // 2 data points: 60 and 40

// Using async/await (iOS 13+, macOS 10.15+)
Task {
    let dataURI = try await chart.toDataURI()
    print(dataURI) // data:image/png;base64,iVBORw0KGgo...
}
