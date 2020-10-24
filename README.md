# cadabra-resources
Notes and tutorials for using Cadabra2.

## Setup
Note, this is by no means a small Dockerfile for Cadabra -- but personally I do not enjoy using `conda` on my work machine, so prefer the modularity of Docker for porting the environment around.

With all of the Cadabra, conda, and Jupyter dependencies, this image comes to a whopping *2.9 GB*. As such, I will not be uploading it to Docker Hub, and instead hosting the Dockerfile here.


**Update:** For the new python jupyter kernel, I created another Dockerfile, this one builds the branch from source and then copies the relevant binaries to a seperate container. The build time is longer, however the resultant final image is *515 MB*, which is a lot more acceptable. 

This container I may make available on Docker Hub in the future for use, since the build time is a little silly.


### Building
```bash
docker build . -t cadabra2-jupyter
```

## Running
```bash
docker run -p 8080:8080 -v $(pwd)/notebooks:/home/cadabra cadabra2-jupyter
```
and follow the tokenized url in your browser to access.

## Notebooks
Most of the notebooks will be derived from a brilliant tutorial by [Leo Brewin](https://github.com/leo-brewin), which you can find [on ArXiv](https://arxiv.org/pdf/1912.08839.pdf).

I include some of my original work without indication, however such amendments serve primarily to aid my own learning.

