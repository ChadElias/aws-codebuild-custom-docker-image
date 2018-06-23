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

### How to allow AWS CLI Commands Permission

AWS CodeBuild will require a Service Role to be used when executing your build. Attach the necessary policies to the custom role that will allow any CLI Commands to be ran.

For example if you wanted to run the following command in your buildspec.yml

```
$ aws s3 cp localfilename s3://CODE_BUILD_ENVIRONMENT_VARIABLE_BUCKET_NAME --profile default
```

You would need an IAM Role to reflect those permissions. For example
```
CodeBuildServiceRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - codebuild.amazonaws.com
            Action:
              - 'sts:AssumeRole'
      Path: "/"
      Policies:
        - PolicyName: CodeBuildAccess
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Resource:
                  - !Sub 'arn:aws:logs:${AWS::Region}:${AWS::AccountId}:log-group:/aws/codebuild/${ProjectName}_build'
                  - !Sub 'arn:aws:logs:${AWS::Region}:${AWS::AccountId}:log-group:/aws/codebuild/${ProjectName}_build:*'
                Action:
                  - 'logs:CreateLogGroup'
                  - 'logs:CreateLogStream'
                  - 'logs:PutLogEvents'
              - Effect: Allow
                Resource:
                  - !Sub 'arn:aws:s3:::${ArtifactBucketNameHere}/*'
                Action:
                  - 's3:GetObject'
                  - 's3:GetObjectVersion'
                  - 's3:PutObject'
```

This is only an example Role and is not intended to be used in a production environment. This is for educational purposes only.