book: http://learnyouahaskell.com/

requirements:
- docker
- my personal setup:
  * atom
  * [hydrogen](https://github.com/nteract/hydrogen)
  * [avi-atom](https://github.com/aviatesk/avi-atom)

spin up IHaskell kernel:
- use 8888 port: `docker run --rm -p 8888:8888 -v "$PWD":/home/jovyan/work -e JUPYTER_TOKEN=DockerJupyterAuthToken gibiansky/ihaskell`
- use whatever port: `docker run --rm -p 8000:8000 -v "$PWD":/home/jovyan/work -e JUPYTER_TOKEN=DockerJupyterAuthToken gibiansky/ihaskell jupyter notebook --no-browser --ip=0.0.0.0 --port=8000`

work in a container:
- `docker run -it --rm -p 8888:8888 -v "$PWD":/home/jovyan/work -e JUPYTER_TOKEN=DockerJupyterAuthToken gibiansky/ihaskell bash`
- `jupyter nbconvert <notebook> --to html`
