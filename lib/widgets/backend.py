# backend.py
from flask import Flask, request, jsonify
import requests
import PyPDF2
import openai
from io import BytesIO

app = Flask(__name__)

openai.api_key = 'your_openai_api_key'

def extract_text_from_pdf(pdf_url):
    response = requests.get(pdf_url)
    pdf_reader = PyPDF2.PdfFileReader(BytesIO(response.content))
    text = ''
    for page in range(pdf_reader.numPages):
        text += pdf_reader.getPage(page).extractText()
    return text

@app.route('/ask', methods=['POST'])
def ask():
    data = request.json
    pdf_url = data['pdfUrl']
    question = data['question']
    
    pdf_text = extract_text_from_pdf(pdf_url)
    
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=f"The following is the content of a PDF document:\n\n{pdf_text}\n\nQ: {question}\nA:",
        max_tokens=100
    )
    
    answer = response.choices[0].text.strip()
    return jsonify({'answer': answer})

if __name__ == '__main__':
    app.run(debug=True)
