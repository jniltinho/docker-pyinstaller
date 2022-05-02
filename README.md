docker-pyinstaller
==========

Docker image for pyinstaller, a static binary packager for python scripts
More informations on [pyinstaller official website](http://www.pyinstaller.org/)

Basic Usage
-----------

Build the image (if you did not pull it from docker hub)

    # docker build --no-cache -t jniltinho/pyinstaller .

Create a directory for your script. In this example, we will use `./data`.

    # mkdir data

Put your python script in the data directory

    # cat <<EOF >data/hello.py
    #!/usr/bin/env python
    print("Hello, World!")
    EOF

Run the docker image, binding the data dir to the container's `/data` directory.
This will compile your script.

    # docker run --rm -ti -v $(pwd)/data:/data jniltinho/pyinstaller build --onefile hello.py

The builder does its duty and you will find the result in the `./data/dist` directory.

    # file ./data/dist/hello
    ./data/dist/hello: ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, stripped
    # ./data/dist/hello
    Hello, World!

Packages Requirements
---------------------

If your script requires additional packages, they must be installed prior to
invoking pyinstaller. There are two ways to achieve this.

### Using the helper

You can create a `.pyinstaller.yml` file at the root of your repo, containing
section describing the packages to install and the commands to run.

The `requirements` section is a list of packages to be installed with `pip`.

    requirements:
      - pyyaml==3.12

The `install` and `build` sections are lists of commands to run to install and
build the binary:

    install:
      - pip install .
    build:
      - pyinstaller --onefile ./hello.spec

Then, start the build using the `autobuild` command:

    # docker run --rm -ti -v $(pwd)/data:/data pyinstaller autobuild

### Using a custom script

You can also write your own script to fit all your needs.

```shell
mkdir data
cat <<EOF >data/build.sh
#!/bin/bash
pip3 install -r requirements.txt
rm -rf slack_client dist *.spec build dist *pycache*
pyinstaller --onefile ./slack_client.py
mv dist/slack_client . ;rm -rf *.spec build dist *pycache*
EOF
 
cat <<EOF >data/requirements.txt
prettytable
requests
slackclient
EOF

cat <<EOF >data/slack_client.py
import logging
logging.basicConfig(level=logging.DEBUG)

import os
from slack import WebClient
from slack.errors import SlackApiError

slack_token = os.environ["SLACK_API_TOKEN"]
client = WebClient(token=slack_token)

try:
  response = client.chat_postMessage(
    channel="C0XXXXXX",
    text="Hello from your app! :tada:"
  )
except SlackApiError as e:
  assert e.response["error"]
EOF

chmod +x data/build.sh
```
 
Then, start the build using the `exec` command:

    # docker run --rm -ti -v $(pwd)/data:/data jniltinho/pyinstaller exec ./build.sh

Customizing the build
---------------------

You can customize the python and pyinstaller versions that you use by defining
the some build args:

- `PYTHON_VERSION`
- `PYINSTALLER_VERSION`

For the helper:

- `PYSCHEMA_VERSION`
- `PYYAML_VERSION`

Example:

    # docker build -t pyinstaller:python2.7 --build-arg PYTHON_VERSION=3.7 .

