resource "aws_instance" "web" {

  ami = "ami-0c02fb55956c7d316"

  instance_type = "t2.micro"

  subnet_id = aws_subnet.private_app_1.id

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  user_data = file("userdata.sh")

  tags = {
    Name = "app-server"
  }
}
resource "aws_lb_target_group_attachment" "app" {

  target_group_arn = aws_lb_target_group.app.arn

  target_id = aws_instance.web.id

  port = 80
}
