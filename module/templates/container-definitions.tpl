[
  {
    "name": "dsa-nginx-reverse-proxy",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "command" : ["nginx", "-g", "daemon off;"],
    "entryPoint": [
        "/docker-entrypoint.sh"
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/dsa-nginx-reverse-proxy",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "environment": [
        {
            "name": "DSA_S3_BUCKET",
            "value": "${dsa_s3_bucket}"
        },
        {
            "name": "DSA_CONFIG_S3_PATH",
            "value": "${config_s3_path}"
        },
        {
            "name": "DSA_LOGS_S3_PATH",
            "value": "${logs_s3_path}"
        }
    ]
  }
]