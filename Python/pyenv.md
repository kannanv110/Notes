# Simple Notes

## pyenv tutorial

- Install Python in your user space
- Install multiple versions of Python
- Specify the exact Python version you want
- Switch between the installed versions

pyenv lets you do all of these things and more.

### Install pyenv

#### Install dependencies

```shell
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
```

#### Install pyenv

```shell
curl https://pyenv.run | bash
```

This will install pyenv along with a few plugins that are useful:

- pyenv: The actual pyenv application
- pyenv-virtualenv: Plugin for pyenv and virtual environments
- pyenv-update: Plugin for updating pyenv
- pyenv-doctor: Plugin to verify that pyenv and build dependencies are installed
- pyenv-which-ext: Plugin to automatically lookup system commands

The installion end like below and perform the steps mention below.

```shell
WARNING: seems you still have not added 'pyenv' to the load path.

# Load pyenv automatically by appending
# the following to 
# ~/.bash_profile if it exists, otherwise ~/.profile (for login shells)
# and ~/.bashrc (for interactive shells) :

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Restart your shell for the changes to take effect.

# Load pyenv-virtualenv automatically by adding
# the following to ~/.bashrc:

eval "$(pyenv virtualenv-init -)"
```

### List of support version 

```shell
pyenv install --list
```

### Install the specific version of python

```shell
pyenv install -v 3.6.8
```
If you dont see the expected python version on list then you may need to update pyenv.

```shell
pyenv update
```
### Get the list of installed python versions

```shell
pyenv versions
```

### To see all pyenv commands

```shell
pyenv commands
```

### Set default python version for the user 
By default the user will have system python as default python and we can change the default python version with `pyenv global`.

This will create ~/.pyenv/version to selected version.

```shell
[kannan@DESKTOP-QKHA0L4 ~]$pyenv versions
* system (set by /home/kannan/.pyenv/version)
  3.6.8
[kannan@DESKTOP-QKHA0L4 ~]$which python3
/home/kannan/.pyenv/shims/python3
[kannan@DESKTOP-QKHA0L4 ~]$pyenv which python3
/usr/bin/python3
[kannan@DESKTOP-QKHA0L4 ~]$pyenv global 3.6.8           
[kannan@DESKTOP-QKHA0L4 ~]$python -V
Python 3.6.8
[kannan@DESKTOP-QKHA0L4 ~]$
```


### Set local python version for the current directory
This will create .python-version file on current directory.
```shell
[kannan@DESKTOP-QKHA0L4 sddc-image-build-pipeline.recent]$pyenv versions
* system (set by /home/kannan/Projects/sddc-image-build-pipeline.recent/.python-version)
  3.6.8
[kannan@DESKTOP-QKHA0L4 sddc-image-build-pipeline.recent]$pyenv local 3.6.8
[kannan@DESKTOP-QKHA0L4 sddc-image-build-pipeline.recent]$pyenv versions
  system
* 3.6.8 (set by /home/kannan/Projects/sddc-image-build-pipeline.recent/.python-version)
[kannan@DESKTOP-QKHA0L4 sddc-image-build-pipeline.recent]$python3 -V
Python 3.6.8
[kannan@DESKTOP-QKHA0L4 sddc-image-build-pipeline.recent]$cd ../
[kannan@DESKTOP-QKHA0L4 Projects]$python3 -V
Python 3.10.12
[kannan@DESKTOP-QKHA0L4 Projects]$
```

### Set python version for shell
This will set the PYENV_VERSION variable to the selected version.

```shell
[kannan@DESKTOP-QKHA0L4 ~]$python3 -V
Python 3.10.12
[kannan@DESKTOP-QKHA0L4 ~]$pyenv shell 3.12.8
[kannan@DESKTOP-QKHA0L4 ~]$echo $PYENV_VERSION
3.12.8
[kannan@DESKTOP-QKHA0L4 ~]$python3 -V
Python 3.12.8
[kannan@DESKTOP-QKHA0L4 ~]$
```
