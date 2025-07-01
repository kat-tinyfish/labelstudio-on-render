FROM heartexlabs/label-studio:latest

ENV DJANGO_CSRF_TRUSTED_ORIGINS=https://tiny-fish-poc-labelstudio.onrender.com
ENV LABEL_STUDIO_ALLOW_ORIGINS=https://tiny-fish-poc-labelstudio.onrender.com
ENV LABEL_STUDIO_DISABLE_SIGNUP_WITHOUT_LINK=true

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
