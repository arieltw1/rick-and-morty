# Image URL to use all building/pushing image targets
IMG_REGISTRY ?= quay.io
IMG_REPO ?= arieltw1
IMG_NAME ?= exercise
IMG_TAG ?= $(shell ./code/version.sh)
IMG = $(IMG_REGISTRY)/$(IMG_REPO)/$(IMG_NAME):$(IMG_TAG)
VALUES_FILE ?= Helm/values.yaml
NAMESPACE ?= rick-and-morty

# Deploy yamls generated from helm debug in the configured Kubernetes cluster in ~/.kube/config
debug:
	kubectl apply -f Helm/debug.yaml

deploy:
	helm install Helm/ --generate-name

# Undeploy in the configured Kubernetes cluster in ~/.kube/config
undeploy:
	kubectl delete namespace $(NAMESPACE)

# Build the docker image
build:
	python3 code/gen_csv.py
	docker build . -t ${IMG}
	rm -rf ./results.csv

# Push the docker image, update helm values and debug the charts
push:
	docker push ${IMG}
	sed -i 's/namespace.*/namespace: "$(NAMESPACE)"/g' $(VALUES_FILE)
	sed -i 's/  registry.*/  registry: "$(IMG_REGISTRY)"/g' $(VALUES_FILE)
	sed -i 's/  repo.*/  repo: "$(IMG_REPO)"/g' $(VALUES_FILE)
	sed -i 's/  name.*/  name: "$(IMG_NAME)"/g' $(VALUES_FILE)
	sed -i 's/  tag.*/  tag: "$(IMG_TAG)"/g' $(VALUES_FILE)
	helm lint Helm/
	helm template --debug Helm/ > Helm/debug.yaml

# Run docker image in a container
run:
	docker run -d -p 8080:8080 --name ${IMG_NAME} -it ${IMG}

# Stop and remove container
rm:
	docker stop ${IMG_NAME}
	docker rm ${IMG_NAME}

