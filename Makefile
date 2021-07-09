# Image URL to use all building/pushing image targets
IMG_REPO ?= quay.io/arieltw1
IMG_NAME ?= exercise
IMG_TAG ?= latest
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
	python3 gen_csv.py
	docker build . -t ${IMG}

# Push the docker image
push:
	docker push ${IMG}

