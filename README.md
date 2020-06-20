- book: http://learnyouahaskell.com/
- requirements:
  * docker
  * atom and [hydrogen](https://github.com/nteract/hydrogen) (and [avi-atom](https://github.com/aviatesk/avi-atom))
- spin up IHaskell: `λ docker run --rm -p 8888:8888 -v "$PWD":/home/jovyan/work -e JUPYTER_TOKEN=DockerJupyterAuthToken gibiansky/ihaskell`
- work in docker container: `λ docker run -it -v "$PWD":/home/jovyan/work gibiansky/ihaskell`
