# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Install Label Studio
RUN pip install --no-cache-dir label-studio

# Expose the default Label Studio port
EXPOSE 8080

RUN echo "DJANGO_CSRF_TRUSTED_ORIGINS=$DJANGO_CSRF_TRUSTED_ORIGINS"

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
CMD ["/app/entrypoint.sh"]
