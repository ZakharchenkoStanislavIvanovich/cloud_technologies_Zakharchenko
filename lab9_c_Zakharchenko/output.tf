output "container_app_url" {
  value = azapi_resource.container_app.output.properties.configuration.ingress.fqdn
}