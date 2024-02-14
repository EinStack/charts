# Helm Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/einstack)](https://artifacthub.io/packages/search?repo=einstack)

This repository contains [Helm](https://helm.sh/) charts for [the EinStack projects](https://github.com/EinStack/).

## Installation

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```bash
helm repo add einstack https://einstack.github.io/charts
```

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages. You can then run `helm search repo einstack` to see the charts.

See the specific installation instructions in the corresponding chart directory.

## Charts

- [Glide Chart](./charts/glide/README.md)
