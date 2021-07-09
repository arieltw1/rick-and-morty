# Image URL to use all building/pushing image targets
IMG_REPO ?= quay.io/arieltw1
IMG_NAME ?= exercise
IMG_TAG ?= $(shell ./code/version.sh)
IMG ?= $(IMG_REPO)/$(IMG_NAME):$(IMG_TAG)

# Deploy in the configured Kubernetes cluster in ~/.kube/config
deploy: 
	cd config/manager && $(KUSTOMIZE) edit set image controller=${IMG}
	$(KUSTOMIZE) build config/default | kubectl apply -f -

# Undeploy in the configured Kubernetes cluster in ~/.kube/config
undeploy:
	$(KUSTOMIZE) build config/default | kubectl delete -f -

# Build the docker image
build:
	python3 code/gen_csv.py
	docker build . -t ${IMG}
	rm -rf ./results.csv

# Push the docker image
push:
	docker push ${IMG}

# Run docker image in a container
run:
	docker run -d -p 8080:8080 --name ${IMG_NAME} -it ${IMG}

# Stop and remove container
rm:
	docker stop ${IMG_NAME}
	docker rm ${IMG_NAME}

