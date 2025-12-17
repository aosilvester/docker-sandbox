# Docker Container
This is a development container built by Alex Silvester. It is designed for developing logic to be deployed to AWS in a sandbox environment. This container is not intended for production or persistent tooling.

---



### Running the container
Initial build: run `docker compose up -d --build`
- this will create the newest configuration of the container locally in a headless method

Then, run `docker exec -it demo-app bash` to bash into the container's shell environment. From there, you are able to run the included python file directly with `python app.py`. To exit the shell, simply type `exit`, or close the terminal.

The `Docker-compose.yml` file configures the contents of the `./app` directory to update in real time to the docker container, so development will not require container rebuilds for each tested change.

### Basic Development in Docker
This container provides a minimal Python environment. It does not include any project-specific dependencies by default. At `./app`, you will find `app.py` and `app_requirements.txt`. For basic development, use this section for logic testing and dependency tracking. Once you bash into the container's shell, you can install any dependencies you add to the requirements file with `pip install -r app_requirements.txt`, and the python script can be run with `python app.py`. Once completed, add this content to your lambda function for integrating with terraform infrastructure

---

#### AWS and Terraform in Docker
To run aws and terraform while bashed into the container, navigate to the terraform directory and run `terraform init`, then `terraform apply`. This will configure terraform infrastructure to the localstack AWS environment.
- S3
    - By default, an s3 bucket is configured in the `main.tf` file. You can test the deployment of this to localstack by running `awslocal s3 ls`

- Lambdas
    - You can test the deployment with `awslocal lambda list-functions`
    - You can test the function itself by running `awslocal lambda invoke --function-name my-local-lambda --cli-binary-format raw-in-base64-out --payload '{"key":"value"}' /tmp/response.json && cat /tmp/response.json` which will encode a json string as the payload, and invoke the lambda function similar to how it would get triggered by an event source, such as S3, SQS, API Gateway, etc.

 For further details, refer to the following documentation
 * [Terraform](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs)
 * [AWS](https://docs.aws.amazon.com/)
 * [LocalStack](https://docs.localstack.cloud/aws/)