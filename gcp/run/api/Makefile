init:
	npm i
	gcloud config set project nfthack2022
	gcloud auth configure-docker
	gcloud config set run/platform managed
	gcloud config set run/region us-west1

local:
	docker compose up

build:
	docker build --platform linux/amd64 -t nfthack2022 .

tag:
	docker tag nfthack2022:latest gcr.io/nfthack2022/api

push:
	docker push gcr.io/nfthack2022/api

init-deploy:
	gcloud run deploy api --image gcr.io/nfthack2022/api --platform managed --region us-west1 --update-secrets INFURA_PROJECT_ID=infura-project-id:latest,INFURA_PROJECT_SECRET=infura-project-secret:latest,OPENSEA_API_KEY=opensea-apikey:latest,API_KEY=api-key:latest

deploy:
	gcloud run deploy api --image gcr.io/nfthack2022/api --platform managed

go:
	make build
	make tag
	make push
	make deploy

build-remote-deploy:
	gcloud builds submit --project nfthack2022 --tag gcr.io/nfthack2022/api
	gcloud run deploy --image gcr.io/nfthack2022/api --platform managed
