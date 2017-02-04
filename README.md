# docker-apache-base
Apache Docker image used as base for pmis-apache image


- Build

  docker build -t apache-base .
  
- Push to registry

  docker tag apache-base dev.sangah.com:5043/apache-base
  docker login dev.sangah.com:5043
  docker push dev.sangah.com:5043/apache-base
