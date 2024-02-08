{{- /*
Copyright EinStack
SPDX-License-Identifier: APACHE-2.0
*/}}

{{- define "glide.pod" -}}
{{- with .Values.image.pullSecrets }}
imagePullSecrets:
{{- toYaml . | nindent 8 }}
{{- end }}
{{- if .Values.podSecurityContext.enabled }}
securityContext:
{{- omit .Values.podSecurityContext "enabled" | toYaml | nindent 8 }}
{{- end }}
containers:
- name: {{ .Chart.Name }}
  {{- if .Values.securityContext.enabled }}
  securityContext:
    {{- omit .Values.securityContext "enabled" | toYaml | nindent 8 }}
  {{- end }}
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.glide.command }}
  command:
    {{- toYaml .Values.glide.command | nindent 12 }}
  {{- end }}
  {{- if .Values.glide.args }}
  args:
    {{- toYaml .Values.glide.args | nindent 12 }}
  {{- end }}
  {{- if .Values.glide.extraEnvVars }}
  env:
    {{- toYaml .Values.glide.extraEnvVars | nindent 12 }}
  {{- end }}
  {{- if or .Values.glide.extraEnvVars .Values.glide.extraEnvVarsSecret }}
  envFrom:
    {{- if .Values.glide.extraEnvVarsFromConfigmap }}
    - configMapRef:
        name: {{ .Values.glide.extraEnvVarsFromConfigmap }}
    {{- end }}
    {{- if .Values.glide.extraEnvVarsSecret }}
    - secretRef:
        name: {{ .Values.glide.extraEnvVarsSecret }}
    {{- end }}
  {{- end }}
  ports:
    - name: http
      containerPort: {{ .Values.glide.ports.gatewayHTTP }}
      protocol: TCP
  livenessProbe:
    httpGet:
      path: /v1/health/
      port: http
  readinessProbe:
    httpGet:
      path: /v1/health/
      port: http
  resources:
    {{- toYaml .Values.resources | nindent 12 }}
  {{- if not .Values.glide.lifecycleHooks }}
  lifecycle:
    {{- toYaml .Values.glide.lifecycleHooks | nindent 12 }}
  {{- end }}
  volumeMounts:
  {{- if (include "glide.configmap" .) }}
  - name: glide-conf
    mountPath: /etc/glide/
  {{- end }}
  {{- if .Values.glide.extraVolumeMounts }}
  {{- toYaml .Values.glide.extraVolumeMounts . | nindent 8 }}
  {{- end }}

{{- with .Values.nodeSelector }}
nodeSelector:
{{- toYaml . | nindent 8 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
{{- toYaml . | nindent 8 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
{{- toYaml . | nindent 8 }}
{{- end }}
{{- end }}
