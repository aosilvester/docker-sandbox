FROM python:3.12-slim

# Install bash, curl, unzip, zip, less, groff, jq, git
RUN apt-get update && \
    apt-get install -y bash curl unzip zip less groff jq git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt



# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip

# Install Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip -o /tmp/terraform.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    rm /tmp/terraform.zip

# Add alias for LocalStack (evaluated at runtime)
RUN echo "alias awslocal='aws --endpoint-url=\$LOCALSTACK_ENDPOINT'" >> /root/.bashrc

# Start with bash by default
CMD ["bash"]
