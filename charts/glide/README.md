# Glide Helm Chart

The helm chart installs [Glide](https://github.com/EinStack/glide/) in a Kubernetes cluster.

## Installation

Before installing the Helm chart, you need to create a Kubernetes secret with your API keys like:

```bash
kubectl create secret generic api-keys --from-literal=OPENAI_API_KEY=sk-abcdXYZ
```

Then, you need to create a custom `values.yaml` file to override the secret name like:

```bash
# save as custom.values.yaml, for example
glide:
    apiKeySecret: "api-keys"
```

### Install from Source

Close this repository and run the following Helm command to install Glide into a cluster you have authenticated with:

```bash
helm upgrade glide-gateway ./charts/glide --values custom.values.yaml --install
```

## Parameters

### Common parameters

| Name                | Description                                                                           | Value |
| ------------------- | ------------------------------------------------------------------------------------- | ----- |
| `nameOverride`      | String to partially override glide.fullname template (will maintain the release name) | `""`  |
| `fullnameOverride`  | String to fully override glide.fullname template                                      | `""`  |
| `namespaceOverride` | String to fully override common.names.namespace                                       | `""`  |

### Glide parameters

| Name                | Description                                                                              | Value                    |
| ------------------- | ---------------------------------------------------------------------------------------- | ------------------------ |
| `image.repository`  | Glide Image name                                                                         | `ghcr.io/einstack/glide` |
| `image.tag`         | Glide Image tag or a digest (in a form of sha256:aa..)                                   | `0.0.1-alpine`           |
| `image.pullPolicy`  | Glide image pull policy                                                                  | `IfNotPresent`           |
| `image.pullSecrets` | Specify docker-registry secret names as an array                                         | `[]`                     |
| `replicaCount`      | The number of replicas to create (more than two are recommended to have some redundancy) | `3`                      |

### Glide Configs

| Name                              | Description                                                                                         | Value                                                                                                                                                                                     |
| --------------------------------- | --------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `glide.command`                   | Override default container command (useful when using custom images)                                | `[]`                                                                                                                                                                                      |
| `glide.args`                      | Override default container args (useful when using custom images)                                   | `["--config=/etc/glide/config.yaml"]`                                                                                                                                                     |
| `glide.ports.gatewayHTTP`         | Override default Glide HTTP server port                                                             | `9099`                                                                                                                                                                                    |
| `glide.config`                    | Glide declarative configuration (deployed as a configmap)                                           | `api:
  http:
    host: 0.0.0.0
    port: 9099
routers:
  language:
    - id: default
      models:
        - id: openai
          openai:
            api_key: "${env:OPENAI_API_KEY}"
` |
| `glide.externalConfigmap`         | An external existing configmap with Glide declarative configuration                                 | `""`                                                                                                                                                                                      |
| `glide.apiKeySecret`              | An external existing secret with API keys referenced in the config (e.g. OPENAI_API_KEY)            | `""`                                                                                                                                                                                      |
| `glide.extraEnvVars`              | Array containing extra env vars to configure Kong                                                   | `[]`                                                                                                                                                                                      |
| `glide.extraEnvVarsFromConfigmap` | ConfigMap containing extra env vars to configure Glide                                              | `""`                                                                                                                                                                                      |
| `glide.extraEnvVarSecrets`        | An array of secrets containing extra sensitive env vars to configure Glide                          | `[]`                                                                                                                                                                                      |
| `glide.lifecycleHooks`            | Lifecycle hooks (Glide container)                                                                   | `{}`                                                                                                                                                                                      |
| `glide.extraVolumes`              | Array of extra volumes to be added to the Glide deployment. Requires setting `extraVolumeMounts`    | `[]`                                                                                                                                                                                      |
| `glide.extraVolumeMounts`         | Array of extra volume mounts to be added to the Glide Container. Normally used with `extraVolumes`. | `[]`                                                                                                                                                                                      |
| `resources.requests`              | The requested resources for the init container                                                      | `{}`                                                                                                                                                                                      |
| `resources.limits`                | The resources limits for the init container                                                         | `{}`                                                                                                                                                                                      |
| `podAnnotations`                  | Pod annotations                                                                                     | `{}`                                                                                                                                                                                      |
| `podLabels`                       | Add additional labels to the pod                                                                    | `{}`                                                                                                                                                                                      |

### Security Parameters

| Name                                          | Description                                                            | Value            |
| --------------------------------------------- | ---------------------------------------------------------------------- | ---------------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Gitea pod                        | `true`           |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                 | `""`             |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `false`          |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`             |
| `podSecurityContext.enabled`                  | Enable Gitea pods' Security Context                                    | `true`           |
| `podSecurityContext.fsGroupChangePolicy`      | Set filesystem group change policy                                     | `Always`         |
| `podSecurityContext.sysctls`                  | Set kernel settings using the sysctl interface                         | `[]`             |
| `podSecurityContext.supplementalGroups`       | Set filesystem extra groups                                            | `[]`             |
| `podSecurityContext.fsGroup`                  | Gitea pods' group ID                                                   | `1001`           |
| `securityContext.enabled`                     | Enabled containers' Security Context                                   | `true`           |
| `securityContext.seLinuxOptions`              | Set SELinux options in container                                       | `nil`            |
| `securityContext.runAsUser`                   | Set containers' Security Context runAsUser                             | `1001`           |
| `securityContext.runAsNonRoot`                | Set container's Security Context runAsNonRoot                          | `true`           |
| `securityContext.privileged`                  | Set container's Security Context privileged                            | `false`          |
| `securityContext.readOnlyRootFilesystem`      | Set container's Security Context readOnlyRootFilesystem                | `true`           |
| `securityContext.allowPrivilegeEscalation`    | Set container's Security Context allowPrivilegeEscalation              | `false`          |
| `securityContext.capabilities.drop`           | List of capabilities to be dropped                                     | `["ALL"]`        |
| `securityContext.seccompProfile.type`         | Set container's Security Context seccomp profile                       | `RuntimeDefault` |

### Traffic Exposure Parameters

| Name                  | Description                                                               | Value       |
| --------------------- | ------------------------------------------------------------------------- | ----------- |
| `hostNetwork`         | Host networking requested for this pod. Use the host's network namespace. | `false`     |
| `dnsPolicy`           | Pod DNS policy ClusterFirst, ClusterFirstWithHostNet, None, Default, None | `""`        |
| `dnsConfig`           | Custom DNS config. Required when DNS policy is None.                      | `{}`        |
| `service.type`        | Kubernetes Service type                                                   | `ClusterIP` |
| `service.port`        | Kubernetes Service port                                                   | `9099`      |
| `service.annotations` | Additional custom annotations for Gitea service                           | `{}`        |

### Scheduling Parameters

| Name                                            | Description                                                                              | Value   |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------- | ------- |
| `priorityClassName`                             | Glide pods' priorityClassName                                                            | `""`    |
| `autoscaling.enabled`                           | Enable autoscaling for replicas (recommended if load is variable)                        | `false` |
| `autoscaling.minReplicas`                       | Minimum number of replicas                                                               | `3`     |
| `autoscaling.maxReplicas`                       | Maximum number of replicas                                                               | `15`    |
| `autoscaling.targetCPUUtilizationPercentage`    | Target CPU utilization percentage                                                        | `80`    |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory utilization percentage                                                     | `""`    |
| `nodeSelector`                                  | Node labels for pod assignment.                                                          | `{}`    |
| `tolerations`                                   | Tolerations for pod assignment                                                           | `[]`    |
| `affinity`                                      | Affinity for pod assignment                                                              | `{}`    |
| `podDisruptionBudget.enabled`                   | Enabled Pod Disruption Budget (highly recommended)                                       | `true`  |
| `podDisruptionBudget.minAvailable`              | Minium number of available replicas during disruption (not less than two is recommended) | `2`     |
| `podDisruptionBudget.maxUnavailable`            | Max number of unavailable replicas at the same time                                      | `""`    |

