# Image URL to use all building/pushing image targets
IMG_REGISTRY ?= quay.io
IMG_REPO ?= arieltw1
IMG_NAME ?= exercise
IMG_TAG ?= $(shell ./code/version.sh)
IMG == $(IMG_REGISTRY)/$(IMG_REPO)/$(IMG_NAME):$(IMG_TAG)

# Deploy in the configured Kubernetes cluster in ~/.kube/config
deploy: 
	kubectl create namespace rick-and-morty	
	kubectl apply -f yamls/

# Undeploy in the configured Kubernetes cluster in ~/.kube/config
undeploy:
	kubectl delete namespace rick-and-morty

# Build the docker image
build:
	python3 code/gen_csv.py
	docker build . -t ${IMG}
	rm -rf ./results.csv

# Push the docker image
push:
	docker push ${IMG}
	sed -i 's/  registry.*/  registry: "$(IMG_REGISTRY)"/g'
	sed -i 's/  repo.*/  repo: "$(IMG_REPO)"/g'
	sed -i 's/  name.*/  name: "$(IMG_NAME)"/g'
	sed -i 's/  tag.*/  tag: "$(IMG_TAG)"/g'

# Run docker image in a container
run:
	docker run -d -p 8080:8080 --name ${IMG_NAME} -it ${IMG}

# Stop and remove container
rm:
	docker stop ${IMG_NAME}
	docker rm ${IMG_NAME}

