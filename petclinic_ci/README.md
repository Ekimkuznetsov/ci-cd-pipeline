# GKE Private Cluster

This example creates a Private GKE Cluster.

With this example, you can create either a regional or zonal cluster. Generally, using a regional cluster is recommended
over a zonal cluster.

Zonal clusters have nodes in a single zones, and will have an outage if that zone has an outage. Regional GKE Clusters
are high-availability clusters where the cluster master is spread across multiple GCP zones. During a zonal outage, the
Kubernetes control plane and a subset of your nodes will still be available, provided that at least 1 zone that your
cluster is running in is still available. Regional control planes remain accessible during upgrades versus zonal control
planes which do not.

By default, regional clusters will create nodes across 3 zones in a region. If you're interested in how nodes are
distributed in regional clusters, read the GCP docs about [balancing across zones](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-autoscaler#balancing_across_zones).

Nodes in a private cluster are only granted private IP addresses; they're not accessible from the public internet, as
part of a defense-in-depth strategy. A private cluster can use a GCP HTTP(S) or Network load balancer to accept public
traffic, or an internal load balancer from within your VPC network.

Private clusters use [Private Google Access](https://cloud.google.com/vpc/docs/private-access-options) to access Google
APIs such as Stackdriver, and to pull container images from Google Container Registry. To use other APIs and services
over the internet, you can use a [`gke-public-cluster`](../gke-public-cluster). Private clusters are
recommended for running most apps and services.

## Limitations

When using a regional cluster, no region shares GPU types across all of their zones; you will need to explicitly specify
the zones your cluster's node pools run in in order to use GPUs.

Node Pools cannot be created in zones without a master cluster; you can update the zones of your cluster master provided
your new zones are within the region your cluster is present in.

<!-- TODO(rileykarson): Clarify what this means when we find out- this is pulled
from the GKE docs. -->
Currently, you cannot use a proxy to reach the cluster master of a regional cluster through its private IP address.

## How do you run these examples?

1. Install [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) v0.14.8 or later.
1. Open `variables.tf` and fill in any required variables that don't have a default.
1. Run `terraform get`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.

#### Optional: Deploy a sample application

1. To setup `kubectl` to access the deployed cluster, run `gcloud beta container clusters get-credentials $CLUSTER_NAME 
--region $REGION --project $PROJECT`, where `CLUSTER_NAME`, `REGION` and `PROJECT` correspond to what you set for the 
input variables.
1. Run `kubectl apply -f example-app/nginx.yml` to create a deployment in your cluster.
1. Run `kubectl get pods` to view the pod status and check that it is ready.
1. Run `kubectl get deployment` to view the deployment status.
1. Run `kubectl port-forward deployment/nginx 8080:80`

Now you should be able to access your `nginx` deployment on http://localhost:8080

#### Destroy the created resources

1. If you deployed the sample application, run `kubectl delete -f example-app/nginx.yml`.
1. Run `terraform destroy`.



## Required OUTPUTS:
client_certificate
Description: Public certificate used by clients to authenticate to the cluster endpoint.
client_key
Description: Private key used by clients to authenticate to the cluster endpoint.
cluster_ca_certificate
Description: The public certificate that is the root of trust for the cluster.
cluster_endpoint
Description: The IP address of the cluster master.









## Required Inputs:
These variables must be set in the module block when using this module.

location string
Description: The location (region or zone) of the GKE cluster.
private_services_secondary_cidr_block string
Description: The IP address range of the VPC's private services secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27. Note: this variable is optional and is used primarily for backwards compatibility, if not specified a range will be calculated using var.secondary_cidr_block, var.secondary_cidr_subnetwork_width_delta and var.secondary_cidr_subnetwork_spacing.
project string
Description: The project ID where all resources will be launched.
public_services_secondary_cidr_block string
Description: The IP address range of the VPC's public services secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27. Note: this variable is optional and is used primarily for backwards compatibility, if not specified a range will be calculated using var.secondary_cidr_block, var.secondary_cidr_subnetwork_width_delta and var.secondary_cidr_subnetwork_spacing.
region string
Description: The region for the network. If the cluster is regional, this must be the same region. Otherwise, it should be the region of the zone.
Optional Inputs
These variables have default values and don't have to be set to use this module. You may set these variables to override their default values.
cluster_name string
Description: The name of the Kubernetes cluster.
Default: "example-private-cluster"

cluster_service_account_description string
Description: A description of the custom service account used for the GKE cluster.
Default: "Example GKE Cluster Service Account managed by Terraform"

cluster_service_account_name string
Description: The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters.
Default: "example-private-cluster-sa"

enable_vertical_pod_autoscaling string
Description: Enable vertical pod autoscaling
Default: true

master_ipv4_cidr_block string
Description: The IP range in CIDR notation (size must be /28) to use for the hosted master network. This range will be used for assigning internal IP addresses to the master or set of masters, as well as the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network.
Default: "10.5.0.0/28"

public_services_secondary_range_name string
Description: The name associated with the services subnetwork secondary range, used when adding an alias IP range to a VM instance. The name must be 1-63 characters long, and comply with RFC1035. The name must be unique within the subnetwork.
Default: "public-services"

public_subnetwork_secondary_range_name string
Description: The name associated with the pod subnetwork secondary range, used when adding an alias IP range to a VM instance. The name must be 1-63 characters long, and comply with RFC1035. The name must be unique within the subnetwork.
Default: "public-cluster"

secondary_cidr_subnetwork_spacing number
Description: How many subnetwork-mask sized spaces to leave between each subnetwork type's secondary ranges.
Default: 0

secondary_cidr_subnetwork_width_delta number
Description: The difference between your network and subnetwork's secondary range netmask; an /16 network and a /20 subnetwork would be 4.
Default: 4

vpc_cidr_block string
Description: The IP address range of the VPC in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27.
Default: "10.3.0.0/16"

vpc_secondary_cidr_block string
Description: The IP address range of the VPC's secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27.
Default: "10.4.0.0/16"