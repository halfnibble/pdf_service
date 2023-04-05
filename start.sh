#!/bin/bash
docker run -d -p 5000:5000 --name pdf_service --restart unless-stopped nostalgio/pdf_service 

# Test with
# curl -H "Content-Type: application/json" -X POST -d '{"filename":"test.pdf","html":"<h1>Hello World</h1>"}' localhost:5000 > test.pdf
