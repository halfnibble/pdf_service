#!/usr/bin/env python3

import pdfkit
from flask import Flask, request, make_response
app = Flask(__name__)

options = {
    'no-print-media-type': '',
    'page-size': 'letter',
    'viewport-size': '1024x768'
}

@app.route('/', methods=['POST'])
def pdf():
    data = request.get_json()
    html = data.get('html', '<h1>No data...</h1>')
    filename = data.get('filename', 'sourcepanel.pdf')
    pdf_doc = pdfkit.from_string(str(html), False, options=options)
    response = make_response(pdf_doc)
    response.headers['Content-Type'] = 'application/pdf'
    response.headers['Content-Disposition'] = 'attachment; filename={0}'.format(
            filename)
    return response

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
