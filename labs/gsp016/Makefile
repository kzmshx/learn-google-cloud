clean:
	rm -rf \
		.terraform \
		.terraform.lock.hcl \
		terraform.tfstate \
		terraform.tfstate.backup

init: clean
	@PROJECT_ID=$$(grep project_id terraform.tfvars | cut -d '"' -f 2); \
	gcloud auth application-default login; \
	gcloud config set project $$PROJECT_ID; \
	terraform init

plan:
	terraform plan

apply:
	terraform apply -auto-approve
