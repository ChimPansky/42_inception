# Creating a new image using docker (https://docs.docker.com/guides/workshop/02_our_app/):

## lets say you have an application repository and you want to run it within a container.

```
> cd /path/to/repository
> touch Dockerfile
```
## add the following contents to Dockerfile:
```
# syntax=docker/dockerfile:1

FROM node:18-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
EXPOSE 3000
```

- each line in the Dockerfile is called a directive.
- yarn is used to install the application's dependencies...
- CMD specifies the default command to run when starting a container from this image

## build the image:
```
> sudo docker build -t image-name .
```
-t means tag the image with the specified name (like an alias)

## run the container:
```
> docker run -dp 127.0.0.1:4000:3000 image-name
```

-d (--detach) means run the container in the background
-p (--publish) creates a port mapping between host and container HOST:CONTAINER (HOST is address of host and CONTAINER is the port of the container). So here port 3000 of the docker is mapped to port 4000 of the localost

if we now go to
http://localhost:4000/
we should see our test application!

## list running docker containers:
```> docker ps```

## list all available docker images:
```> docker images```

## stop a specific docker container (get the container_id from docker ps):
```> docker stop <container_id>```

# Add a local docker image to dockerhub:

## lets say you have the following images:
```
> docker images
REPOSITORY                TAG       IMAGE ID       CREATED         SIZE
myapp                     latest    abcdef123456   2 hours ago     500MB
myusername/myapp          v1        abcdef123456   2 hours ago     500MB
newapp                    latest    bcdefg234567   1 hours ago     250MB
```
## and you want to push newapp to dockerhub...
```> docker tag newapp myusername/newapp:mytag```
(tagname is optional, default is "latest")
## now docker images will output:
```
REPOSITORY                TAG       IMAGE ID       CREATED         SIZE
myapp                     latest    abcdef123456   2 hours ago     500MB
myusername/myapp          v1        abcdef123456   2 hours ago     500MB
newapp                    latest    bcdefg234567   1 hours ago     250MB
myusername/newapp         mytag     bcdefg234567   1 hours ago     250MB
```
## then, login to dockerhub:
```> docker login```
## push the local image to dockerhub:
```> docker push myusername/newapp:mytag```
