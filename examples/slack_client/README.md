# Compile Python3 Script

```shell
git clone https://github.com/jniltinho/docker-pyinstaller.git
cd docker-pyinstaller/examples/slack_client
chmod +x data/build.sh
docker run --rm -ti -v $(pwd)/data:/data ghcr.io/jniltinho/pyinstaller exec ./build.sh
```
