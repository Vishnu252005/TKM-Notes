from flask import Flask, request, jsonify
import requests
import PyPDF2
from spacy import displacy  # Assuming spaCy is installed

# Replace with Cloud Natural Language API credentials (if using)
# Alternatively, replace with third-party API details (if using)
API_KEY = "AIzaSyBFcm7qENQj5aqFdnSJzQXkJsa61jjmweI"

app = Flask(__name__)


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

    # Option 1: Using Cloud Natural Language API (replace with your API call)
    # response = requests.post(
    #     "https://language.googleapis.com/v1/documents:analyzeSentiment",
    #     headers={"Authorization": f"Bearer {API_KEY}"},
    #     json={"document": {"content": pdf_text}})
    # answer = "..."  # Extract answer based on API response

    # Option 2: Using spaCy (example for named entity recognition)
    nlp = spacy.load("en_core_web_sm")  # Load spaCy model
    doc = nlp(pdf_text)
    entities = [ent.text for ent in doc.ents]  # Extract named entities

    # Answer based on identified entities and question (logic required)
    answer = f"Found entities in the document: {', '.join(entities)}"
    # Further processing to answer the question based on entities and context

    # Option 3: Using Third-Party API (replace with your API call)
    # response = requests.post(
    #     "https://<your-api-endpoint>",
    #     json={"question": question, "text": pdf_text})
    # answer = response.json()["answer"]

    return jsonify({'answer': answer})


if __name__ == '__main__':
    app.run(debug=True)
