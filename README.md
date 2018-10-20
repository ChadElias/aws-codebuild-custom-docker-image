# AWS CodeBuild Custom Starter Image

This Docker image is intended to be a starter image for those developers experimenting with custom CodeBuilds.

### How to build the Docker image

Steps to build image

```
$ git clone https://github.com/ChadElias/aws-codebuild-custom-docker-image.git
$ cd aws-codebuild-custom-docker-image
$ docker build -t IMAGE_NAME ./
$ docker run -it IMAGE_NAME
```