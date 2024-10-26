from flask import Flask, request, jsonify
from PIL import Image
import torch
from transformers import CLIPProcessor, CLIPModel
import io

# Initialize Flask app
app = Flask(__name__)

# Load the CLIP model and processor
model = CLIPModel.from_pretrained("openai/clip-vit-base-patch16")
processor = CLIPProcessor.from_pretrained("openai/clip-vit-base-patch16")

# Define complaint categories
categories = {
    "Safety": ["crime", "harassment"],
    "Sanitation": ["litter", "garbage"],
    "Infrastructure": ["pothole", "repair"]
}

@app.route('/', methods=['GET'])
def home():
    return "Welcome to the Image Classification API! Use the /upload endpoint to submit an image."

@app.route('/upload', methods=['POST'])
def upload_image():
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400
    
    # Load the image
    image = Image.open(io.BytesIO(file.read()))

    # Preprocess the image for the CLIP model
    inputs = processor(images=image, return_tensors="pt", padding=True, truncation=True)

    # Get the CLIP features
    with torch.no_grad():
        image_features = model.get_image_features(**inputs)

    # Normalize features for CLIP
    image_features = image_features / image_features.norm(dim=-1, keepdim=True)

    # Prepare text prompts for CLIP
    text_prompts = [
        f"Image showing {keyword} related to {category.lower()}"
        for category, keywords in categories.items() for keyword in keywords
    ]
    text_inputs = processor(text=text_prompts, return_tensors="pt", padding=True, truncation=True)

    with torch.no_grad():
        # Get CLIP text features
        text_features = model.get_text_features(**text_inputs)
        text_features = text_features / text_features.norm(dim=-1, keepdim=True)

        # Compute similarity
        similarity = (image_features @ text_features.T).softmax(dim=-1)

    # Determine categorization based on highest similarity
    keyword_index = similarity.argmax().item()

    # Get the corresponding category
    category_name = text_prompts[keyword_index]

    # Respond based on the category
    response = "Relevant" if category_name in categories else "Irrelevant"
    return jsonify({"status": response, "category": category_name})

if __name__ == '__main__':
    app.run(debug=True)
