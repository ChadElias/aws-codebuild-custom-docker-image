# AWS CodeBuild Custom Starter Image

This Docker image is intended to be a starter image for those developers experimenting with custom CodeBuilds.

### How to build Docker image

Steps to build image

```
$ git clone https://github.com/ChadElias/aws-codebuild-custom-docker-image.git
$ cd aws-codebuild-custom-docker-image
$ docker build -t nameofimagehere ./
$ docker run -it nameofimagehere
```