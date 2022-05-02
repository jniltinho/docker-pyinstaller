#!/bin/bash
## docker run --rm -ti -v $(pwd)/data:/data jniltinho/pyinstaller exec ./build.sh

pip3 install -r requirements.txt
rm -rf slack_client dist *.spec build dist *pycache*
pyinstaller --onefile ./slack_client.py
mv dist/slack_client . ;rm -rf *.spec build dist *pycache*
