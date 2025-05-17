# resource "aws_api_gateway_rest_api" "matching_engine_api" {
#   name = "matching_engine_api"
# }

# resource "aws_api_gateway_resource" "matching_engine_api_resource" {
#   rest_api_id = aws_api_gateway_rest_api.matching_engine_api.id
#   parent_id   = aws_api_gateway_rest_api.matching_engine_api.root_resource_id
#   path_part   = "match"
# }

# resource "aws_api_gateway_method" "matching_engine_api_method" {
#   rest_api_id      = aws_api_gateway_rest_api.matching_engine_api.id
#   resource_id      = aws_api_gateway_resource.matching_engine_api_resource.id
#   api_key_required = false
#   http_method      = "POST"
#   authorization    = "NONE"
# }

# resource "aws_api_gateway_integration" "lambda_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.matching_engine_api.id
#   resource_id             = aws_api_gateway_resource.matching_engine_api_resource.id
#   http_method             = aws_api_gateway_method.matching_engine_api_method.http_method
#   type                    = "AWS"
#   integration_http_method = "POST"
#   passthrough_behavior    = "NEVER"
#   credentials             = aws_iam_role.matching_engine_api_role.arn
#   uri                     = "arn:aws:apigateway:${var.aws_region}:sqs:path/${aws_sqs_queue.cola_peticiones_fifo.name}"

#   request_parameters = {
#     "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
#   }

#   request_templates = {
#     "application/json" = "Action=SendMessage&MessageBody=$input.body"
#   }
# }

# resource "aws_api_gateway_deployment" "rest_api_deployment" {
#   rest_api_id = aws_api_gateway_rest_api.matching_engine_api.id
#   triggers = {
#     redeployment = sha1(jsonencode([
#       aws_api_gateway_resource.matching_engine_api_resource.id,
#       aws_api_gateway_method.matching_engine_api_method.id,
#       aws_api_gateway_integration.lambda_integration.id
#     ]))
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_api_gateway_stage" "api_stage" {
#   stage_name    = "dev"
#   rest_api_id   = aws_api_gateway_rest_api.matching_engine_api.id
#   deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
# }

# resource "aws_lambda_permission" "allow_api_gw_matching_engine" {
#     statement_id  = "AllowExecutionFromAPIGateway"
#     action        = "lambda:InvokeFunction"
#     function_name = aws_lambda_function.matching_engine_lambda.function_name
#     principal     = "apigateway.amazonaws.com"
#     source_arn    = "${aws_api_gateway_rest_api.matching_engine_api.execution_arn}/*/*"
# }



# API Gateway REST API
resource "aws_api_gateway_rest_api" "main" {
  name        = var.api_gateway_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "credito-solicitud"
}

# API Gateway root resource method
resource "aws_api_gateway_method" "root" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  api_key_required = false
  http_method   = "ANY"
  authorization = "NONE"
}

# API Gateway integration with the load balancer
resource "aws_api_gateway_integration" "lb_integration" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.root.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${aws_lb.application.dns_name}"
  connection_type         = "INTERNET"
}

# API Gateway deployment
resource "aws_api_gateway_deployment" "main" {
	rest_api_id = aws_api_gateway_rest_api.main.id
	triggers = {
	redeployment = sha1(jsonencode([
		aws_api_gateway_resource.api_resource.id,
		aws_api_gateway_method.root.id,
		aws_api_gateway_integration.lb_integration.id
	]))
	}

  lifecycle {
    create_before_destroy = true
  }
}

# API Gateway stage
resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = var.environment
}

# API Gateway CloudWatch logs
resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/aws/apigateway/${aws_api_gateway_rest_api.main.name}"
  retention_in_days = 7
}

# API Gateway Method settings for logging
resource "aws_api_gateway_method_settings" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}