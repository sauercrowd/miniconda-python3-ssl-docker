#!/bin/sh
openssl req -x509 -nodes -days 365 -subj "/C=DE/ST=Sauercrowd/L=Sauercrowd/O=Sauercrowd/OU=IT Department/CN=example.com" -newkey rsa:2048 -keyout /home/conda/ssl/jupyter.key -out /home/conda/ssl/jupyter.crt
/home/conda/anaconda3/bin/jupyter notebook --certfile=/home/conda/ssl/jupyter.crt --keyfile=/home/conda/ssl/jupyter.key --ip=0.0.0.0 --no-browser
