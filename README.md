# Helm Charts

This repository contains [Helm](https://helm.sh/) charts for [the EinStack projects](https://github.com/EinStack/).

## Charts

- [Glide Chart](./charts/glide/README.md)

## Installation

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

helm repo add einstack https://einstack.github.io/helm-charts

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo einstack` to see the charts.

To install the Glide's chart:

    helm install glide-gateway einstack/glide

To uninstall the chart:

    helm delete glide-gateway
