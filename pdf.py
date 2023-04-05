#!/usr/bin/env python3

import pdfkit
from flask import Flask, abort, make_response, request

app = Flask(__name__)

default_options = {
    "no-print-media-type": "",
    "margin-bottom": "15mm",
    "margin-top": "15mm",
    "page-size": "letter",
    "viewport-size": "1024x768",
}


@app.route("/", methods=["POST"])
def pdf():
    options = default_options.copy()
    data = request.get_json()
    html = data.get("html", "<h1>No data...</h1>")
    # Optional header attributes
    header = data.get("header", None)
    if header is not None and isinstance(header, dict):
        for key, value in header.items():
            options["header-" + key] = value
    # Optional footer attributes
    footer = data.get("footer", None)
    if footer is not None and isinstance(footer, dict):
        for key, value in footer.items():
            options["footer-" + key] = value
    filename = data.get("filename", "sourcepanel.pdf")
    try:
        pdf_doc = pdfkit.from_string(str(html), False, options=options)
    except Exception as err:
        msg = str(err)
        if "ProtocolUnknownError" in msg:
            msg = f"Check URLS in HTML to make sure they are valid and public. Error: {err}"
        abort(400, msg)
    response = make_response(pdf_doc)
    response.headers["Content-Type"] = "application/pdf"
    disposition = "attachment; filename={0}".format(filename)
    response.headers["Content-Disposition"] = disposition
    return response


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
