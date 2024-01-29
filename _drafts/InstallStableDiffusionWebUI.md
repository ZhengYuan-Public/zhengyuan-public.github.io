

### Fix Network Issues for Chinese Users

The pip install command is located in the file `modules/launch_utils.py`

```python
# Find this line, use -i to specify a pip source
# return run(f'"{python}" -m pip {command} --prefer-binary{index_url_line}, desc=f"Installing {desc}", errdesc=f"Couldn't install {desc}", live=live)

return run(f'"{python}" -m pip {command} --prefer-binary{index_url_line} -i https://pypi.tuna.tsinghua.edu.cn/simple', desc=f"Installing {desc}", errdesc=f"Couldn't install {desc}", live=live)
```

### Install xformers (Linux)

```bash
$ cd ~/Documents/stable-disfussion-webui
$ source ./venv/bin/activate
$ cd repositories
$ git clone https://github.com/facebookresearch/xformers.git
$ cd xformers
$ git submodule update --init --recursive
$ pip install wheel
$ pip install -r requirements.txt
$ pip install -e .
```

### Install TCMalloc

```bash
$ sudo apt-get install google-perftools
```

