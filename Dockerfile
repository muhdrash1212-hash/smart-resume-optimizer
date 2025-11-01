FROM python:3.11-slim

# Set workdir
WORKDIR /app

# Install system deps (for FAISS + PyMuPDF)
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first (cache layer)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app
COPY . .

# Create dirs
RUN mkdir -p /tmp/uploads /tmp/vector_index

# Expose port
EXPOSE 8080

# Run with memory limit
CMD ["waitress-serve", "--port=8080", "--host=0.0.0.0", "app:app"]