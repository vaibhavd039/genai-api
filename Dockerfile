# 1. Use the official Python 3.10 slim image (matches your version)
FROM python:3.10-slim

RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH


# 2. Set the working directory inside the container
WORKDIR $HOME/app

# 3. Copy requirements first (This caches the installation layer)
COPY --chown=user requirements.txt .

# 4. Install dependencies
# --no-cache-dir keeps the image small
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of your code
# (The .dockerignore file will stop .env from being copied here)
COPY --chown=user . .

# 6. Expose the app port
EXPOSE 7860

# 7. Run the application
# Use fastapi_app:app (not main:app) and honor Cloud Run PORT if provided
CMD ["uvicorn", "fastapi_app:app", "--host", "0.0.0.0", "--port", "7860"]
