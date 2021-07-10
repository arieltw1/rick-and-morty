# **Rick and Morty exercise**
A **lazy** walkthrough of building and understanding Ansible-based operators for cloudlets.
  
## Testing an Ansible Operator on a cluster
testing the operator inside of a pod on a Kubernetes cluster is desired. Running as a pod inside a Kubernetes cluster is preferred for production use.

**Prerequisites**
- Bins:
	- helm
	- make
	- kubectl
	- docker
  - python3

- Python modules:
	- tablib==3.0.0
  - requests==2.20.0
  - Flask==2.0.1
  - py_healthcheck==1.10.1

- Images:
	- python:3.8-alpine
	
- User authorized with permissions to create a namespace and manage it.

> **Note:** Before you start working with the content of this repo, make sure to login to the relevant registry and cluster.

To build and push our service image to a registry:
`$ make build push` 

All the variables are set inside the **Makefile** however, most of them can be set on the go.
if you want to overwrite what is set in the **Makefile**.
for example- setting IMG\_TAG parameter like so:
`$ make build push IMG_TAG=v0.0.1`


In order to run our image localy for the first time we can run:
`$ make build push run`
When we want to rerun the container using a new image we may run:
`$ make build push rm run`
We can also rerun the container without building and pushing the image again by using:
`$ make rm run IMG_TAG=1.10072021-d2b5e26`


Deploy the foo-operator:
`$ make install`
`$ make deploy IMG=quay.io/example/foo-operator:v0.0.1`

The &#39;install&#39; command simply deploy the CRD and the &#39;deploy&#39; deploy all the rest of the necessary resources (except the CR obviously)

If you would like to create the manifests themselves and go over them you can use the &#39;kustomize&#39; command, however we have a Make command for all of that:
`$ make it-rain IMG_TAG=v0.0.1`

Which build, push the necessary images and create all the needed manifests to deploy on a cluster. You can find them under the build directory inside your project.

## Files structure
  
| **File Name** | **description** |
| --- | --- |
| Dockerfile | Original docker file, used when building in an open environment (civilian) |
| Dockerfile.offline | Similar to the original docker file, but used in offline environments |
| Makefile | containing a set of directives used by a &#39;make&#39; tool to help build and manage the projects automatically |
| PROJECT | A YAML file containing meta information for the operator. |
| ansible.cfg | Certain settings in ansible adjustable via this file, it is copied when building the image. |
| extras.yml | Extra permissions we need to have when deploying on cloudlets (might need additions depending on your use case) |
| requirements.yml | List of the required ansible collections (might need additions depending on your use case) |
| watches.yaml | The Group, Version, and Kind of the resources to watch, and the Ansible invocation method. New entries are added via the operator SDK &#39;create api&#39; command. |

## The Deployment

The default Deployment manifest generated for the operator can be found in the **config/manager/manager.yaml** file. By default, the Deployment is named as &#39;controller-manager&#39;. It contains a single container named &#39;manager&#39;, and it may pick up a sidecar patch from the config/default directory. The Deployment will create a single Pod.

For the container in the Pod, there are a few things to note. The default Deployment contains a placeholder for the container image to use, so you cannot create a meaningful operator using the YAML file directly. To deploy the operator, you will **run** `make deploy IMG=<IMG>`. The image name and tag are then patched using kustomize.
