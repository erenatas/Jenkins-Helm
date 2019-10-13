{{- define "jenkins.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "jenkins.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "jenkins.master.kubernetesNamespace" -}}
  {{- if .Values.master.kubernetesNamespace -}}
    {{- .Values.master.kubernetesNamespace -}}
  {{- else -}}
    {{- if .Values.namespaceOverride -}}
      {{- .Values.namespaceOverride -}}
    {{- else -}}
      {{- .Release.Namespace -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "jenkins.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{- define "jenkins.serviceAccountName" -}}
    {{ default (include "jenkins.fullname" .) .Values.serviceAccount.name }}
{{- end -}}

{{- define "jenkins.serviceAccountAgentName" -}}
    {{ default (printf "%s-%s" (include "jenkins.fullname" .) "agent") .Values.serviceAccountAgent.name }}
{{- end -}}

{{- define "jenkins.url" -}}
    {{- default "http" .Values.master.jenkinsUrlProtocol }}://{{ template "jenkins.fullname" . }}:{{.Values.master.servicePort}}{{ default "" .Values.master.jenkinsUriPrefix }}
{{- end -}}