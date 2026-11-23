import SwiftUI
import WebKit

struct YoutubePlayer: UIViewRepresentable {
    let videoId: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .black

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport"
                  content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
            <style>
                body {
                    margin: 0;
                    padding: 0;
                    background-color: black;
                }
                iframe {
                    position: absolute;
                    width: 100%;
                    height: 100%;
                    border: 0;
                }
            </style>
        </head>
        <body>
            <iframe
                src="https://www.youtube.com/embed/\(videoId)?playsinline=1"
                referrerpolicy="strict-origin-when-cross-origin"
                allow="autoplay; encrypted-media; picture-in-picture"
                allowfullscreen>
            </iframe>
        </body>
        </html>
        """

        // Replace with a domain associated with your app/developer.
        let baseURL = URL(string: "https://example.com")!

        uiView.loadHTMLString(html, baseURL: baseURL)
    }
}
