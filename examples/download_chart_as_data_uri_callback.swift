import ImageCharts

let chart = ImageCharts()
    .cht("bvg") // vertical bar chart
    .chs("300x300") // 300px x 300px
    .chd("a:60,40") // 2 data points: 60 and 40

// Using completion handler
chart.toDataURI { result in
    switch result {
    case .success(let dataURI):
        print(dataURI) // data:image/png;base64,iVBORw0KGgo...
    case .failure(let error):
        print("Error: \(error)")
    }
}
