#! /bin/bash
                sudo apt update -y
                sudo apt install nginx -y
                sudo systemctl start nginx
                sudo bash -c 'echo EM DEP LAM > /var/www/html/index.html'