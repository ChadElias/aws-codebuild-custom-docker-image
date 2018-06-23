# AWS CodeBuild Custom Starter Image

This Docker image is intended to be a starter image for those developers experimenting with custom CodeBuilds.

### How to build Docker image

Steps to build image

```
$ git clone https://github.com/ChadElias/aws-codebuild-custom-docker-image.git
$ cd aws-codebuild-custom-docker-image
$ docker build -t IMAGE_NAME ./
$ docker run -it IMAGE_NAME
```

### How to Create ECR Repository

Within the same directory as your Dockerfile

```
RUN aws --region REGION_NAME ecr create-repository --repository-name ECR_REPO_NAME --profile default
```

Note your response will contain information on your newly created ECR Repo

```
RUN docker tag dotnet2node AWS_ACCOUNT_ID.dkr.ecr.REGION_NAME.amazonaws.com/IMAGE_NAME
```

```
RUN aws ecr get-login --no-include-email --region REGION_NAME --profile default
```

This will return a docker login. Copy from 'docker' until 'amazonaws.com'
Paste that back into your terminal and hit Enter. There are more secure ways of accomplishing this, but this is for demonstration purposes only. After successfuly logon.

```
RUN docker push AWS_ACCOUNT_ID.dkr.ecr.REGION_NAME.amazonaws.com/IMAGE_NAME
```

This will push to your ECR Repo. Now you need to edit the repo policy.

```
Select your repo in ECR
Click on the 'Permissions' Tab
Click Add
Select the policy you want to add
Click Save All
```

### How to allow AWS CLI Commands Permission

AWS CodeBuild will require a Service Role to be used when executing your build. Attach the necessary policies to the custom role that will allow any CLI Commands to be ran.

For example if you wanted to run the following command in your buildspec.yml

```
$ aws s3 cp localfilename s3://BUILD_OUTPUT_BUCKET --profile default
```

You would need an IAM Role in your CloudFormation script to reflect those permissions. For example
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

Then you could attach this role to a CodeBuild project in your same CloudFormation Script

```
CodeBuildProject:
    Type: AWS::CodeBuild::Project
    Properties:
      Name: !Sub '${ProjectName}_build'
      Description: Build Project
      Artifacts:
        Type: CODEPIPELINE
      Environment:
        ComputeType: BUILD_GENERAL1_SMALL
        Image: !Sub ${AWS::AccountId}.dkr.ecr.${AWS::Region}.amazonaws.com/${EcrImageName}:${EcrImageTag}
        Type: LINUX_CONTAINER
        EnvironmentVariables:
          - Name: BUILD_OUTPUT_BUCKET
            Value: !Ref BuildArtifactsBucket
      ServiceRole: !GetAtt CodeBuildServiceRole.Arn
      Source: 
          Type: CODEPIPELINE
```

This is only an example Role and is not intended to be used in a production environment. This is for educational purposes only.