from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import os

PORT = 8000
DIRECTORY = "pages"

class PortfolioHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

if __name__ == "__main__":
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    # ThreadingHTTPServer, não HTTPServer: o navegador abre várias conexões em
    # paralelo para os ~20 assets da página, e um servidor de thread única as
    # atende em fila — a página carrega aos pedaços.
    with ThreadingHTTPServer(("0.0.0.0", PORT), PortfolioHandler) as httpd:
        print(f"Servidor rodando em http://localhost:{PORT}/index.html")
        httpd.serve_forever()
