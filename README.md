# Yam Education – Backend API (Fargate Deployment)

This repository contains the backend API for Yam Education, deployed on AWS ECS Fargate using Terraform and Docker.

---

##  Architecture Overview

- **Flask API** packaged into a Docker container  
- **ECR** hosts the Docker images  
- **ECS Fargate** runs the API without managing servers  
- **Application Load Balancer (ALB)** exposes the API endpoint  
- **CloudWatch Logs** collects logs  
- **Terraform** handles full infrastructure provisioning  

---

##  API Endpoints

### **1. Root Endpoint**
```
GET /
```
**Response**
```json
{
  "service": "yam-edu-sample-api",
  "message": "Hello from ECS Fargate!",
  "env": "dev"
}
```

### **2. Health Check**
```
GET /health
```
**Response**
```json
{
  "status": "ok",
  "service": "yam-api"
}
```

---

##  Local Development

### 1️⃣ Build Docker image
```
docker build -t yam-repo:latest .
```

### 2️⃣ Run locally
```
docker run -d -p 8080:8000 yam-repo:latest
```

### 3️⃣ Test locally
```
curl http://localhost:8080/
curl http://localhost:8080/health
```

---

## ☁️ AWS Deployment (via Terraform)

### 1️⃣ Push image to ECR
```
aws ecr get-login-password --region us-east-1 | \
docker login --username AWS --password-stdin 411902770159.dkr.ecr.us-east-1.amazonaws.com

docker tag yam-repo:latest 411902770159.dkr.ecr.us-east-1.amazonaws.com/yam-repo:v3
docker push 411902770159.dkr.ecr.us-east-1.amazonaws.com/yam-repo:v3
```

### 2️⃣ Deploy resources
```
cd terraform/
terraform apply -auto-approve
```

### 3️⃣ Retrieve ALB DNS
```
terraform output -raw alb_dns_name
```

### 4️⃣ Test live API
```
curl http://YOUR-ALB-DNS/
curl http://YOUR-ALB-DNS/health
```

---

##  Logging & Monitoring

### View logs
```
aws logs tail /ecs/yam-education --follow
```

---

##  Contact
Maintainer: **Oceane Audrey BALIMA**  
Email: **obalima@introgroup-tech.com**
