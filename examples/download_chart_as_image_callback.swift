import ImageCharts

let chart = ImageCharts()
    .cht("bvg") // vertical bar chart
    .chs("300x300") // 300px x 300px
    .chd("a:60,40") // 2 data points: 60 and 40

// Using completion handler
chart.toFile("/path/to/chart.png") { result in
    switch result {
    case .success:
        print("Chart saved successfully!")
    case .failure(let error):
        print("Error: \(error)")
    }
}
