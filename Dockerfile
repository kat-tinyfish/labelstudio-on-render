FROM heartexlabs/label-studio:latest

ENV DJANGO_CSRF_TRUSTED_ORIGINS=https://tiny-fish-poc-labelstudio.onrender.com
ENV LABEL_STUDIO_ALLOW_ORIGINS=https://tiny-fish-poc-labelstudio.onrender.com
ENV LABEL_STUDIO_DISABLE_SIGNUP_WITHOUT_LINK=true

# Copy entrypoint script to a writable directory
COPY entrypoint.sh /label-studio/entrypoint.sh
RUN chmod +x /label-studio/entrypoint.sh

ENTRYPOINT ["/label-studio/entrypoint.sh"]
