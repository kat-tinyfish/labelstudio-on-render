# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Install Label Studio
RUN pip install --no-cache-dir label-studio

# Copy entrypoint script and set permissions as root
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Create a non-root user for security
RUN useradd -m labelstudio

# Create a directory for persistent data
RUN mkdir -p /data && chown labelstudio:labelstudio /data
VOLUME ["/data"]

# Expose the default Label Studio port
EXPOSE 8080

# Switch to non-root user
USER labelstudio

# Healthcheck for Render.com
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Set environment variables for admin user
ENV LS_ADMIN_USERNAME=admin
ENV LS_ADMIN_PASSWORD=adminpassword
ENV LS_ADMIN_EMAIL=admin@example.com

ENTRYPOINT ["/app/entrypoint.sh"]
