docker logs -f `docker ps -a | grep docker-django_python | awk '{ print $1 }'`
