# cadabra-resources
Notes and tutorials for using Cadabra2.

## Setup
Note, this is by no means a small Dockerfile for Cadabra -- but personally I do not enjoy using `conda` on my work machine, so prefer the modularity of Docker for porting the environment around.

With all of the Cadabra, conda, and Jupyter dependencies, this image comes to a whopping *2.9 GB*. As such, I will not be uploading it to Docker Hub, and instead hosting the Dockerfile here.


### Building
```bash
docker build . -t cadabra2 
```

## Running
```bash
docker run -p 8080:8080 -v $(pwd)/notebooks:/notebooks cadabra2 
```
and follow the tokenized url in your browser to access.