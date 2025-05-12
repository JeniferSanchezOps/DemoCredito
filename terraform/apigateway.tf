resource "aws_apigatewayv2_api" "credito_api" {
  name          = "credito-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "credito_stage" {
  api_id      = aws_apigatewayv2_api.credito_api.id
  name        = "prod"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "credito_integration" {
  api_id           = aws_apigatewayv2_api.credito_api.id
  integration_type = "HTTP_PROXY"
  integration_uri  = "http://<YOUR-SERVICE-URL>:8080/solicitud"
  integration_method = "POST"
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "credito_route" {
  api_id    = aws_apigatewayv2_api.credito_api.id
  route_key = "POST /solicitud"
  target    = "integrations/${aws_apigatewayv2_integration.credito_integration.id}"
}