from http.server import SimpleHTTPRequestHandler, HTTPServer
import os

PORT = 8000
DIRECTORY = "pages"

class PortfolioHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

if __name__ == "__main__":
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    with HTTPServer(("0.0.0.0", PORT), PortfolioHandler) as httpd:
        print(f"Servidor rodando em http://localhost:{PORT}/index.html")
        httpd.serve_forever()
