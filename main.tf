
//กำหนด Provider ที่ต้องใช้ บอกให้ Terraform ใช้ Docker Provider (kreuzwerker/docker) เวอร์ชัน 3.0.2
terraform { 
  required_providers { 
    docker = { 
      source  = "kreuzwerker/docker" 
      version = "3.0.2" 
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    } 
  } 
} 

//กำหนด Provider สำหรับ Docker ให้ Terraform เชื่อมต่อกับ Docker Engine บน Windows ผ่าน Named Pipe (npipe://)
provider "docker" { 
  host = "npipe:////./pipe/docker_engine" 
} 

//รัน PowerShell Script (buildImg.ps1) ก่อนสร้าง Docker Image
resource "null_resource" "execute_script" {
  provisioner "local-exec" {
    command = "powershell.exe ./buildImg.ps1"  
    working_dir = "${path.module}"  //${path.module} หมายถึงโฟลเดอร์ของ Terraform Configuration
  }
}

//สร้าง Docker Image
resource "docker_image" "my_app" {
  name = "node-express-app:latest"
  depends_on = [null_resource.execute_script] //รอให้ Terraform รันสคริปต์ buildImg.ps1 ให้เสร็จก่อน แล้วค่อยสร้าง Docker Image
}

//
resource "docker_container" "my_container" {
  name = "my-express-app"
  image = docker_image.my_app.name //ใช้ Docker Image ที่สร้างในขั้นตอนก่อนหน้า
  ports {
    internal = 3002 //แอป Node.js ทำงานที่พอร์ต 3002 ใน Container
    external = 3002 // เปิดให้เข้าถึงผ่านพอร์ต 80 จากเครื่องภายนอก 
  }
}

/*
เริ่มต้น Terraform   - terraform init
ตรวจสอบก่อนรัน  - terraform plan
รัน Terraform เพื่อสร้างและรัน Docker  - terraform apply -auto-approve
เช็คว่า Container ทำงานอยู่หรือไม่  - docker ps
ลบ Container และ Image ที่ Terraform สร้างขึ้น  - terraform destroy -auto-approve
*/
