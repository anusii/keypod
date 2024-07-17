# KeyPod Installers

Flutter supports multiple platforms so that Flutter based apps will run native
and similarly on Android, iOS, Linux, MacOS, and Windows, as well as directly in a
browser from the web.

## Prerequisite

There are no specific prerequisites for KeyPod.

## Android Side Load

For this SolidCommunity app, from your Android device's browser, simply visit 
the Solid Community [Installer](https://solidcommunity.au/installers/keypod.apk] 
for keypod.

## Linux

### Prerequisite

### Tar Install

Download
[keypod.tar.gz](https://solidcommunity.au/installers/keypod.tar.gz):

```bash
wget https://solidcommunity.au/installers/keypod.tar.gz
```

**Quick Start**

To try it out:

```bash
wget https://solidcommunity.au/installers/keypod.tar.gz
tar zxvf keypod.tar.gz
```

Then simply run the executable:

```bash
keypod/keypod
```

**Local User Install**

To install for the local user the package can be placed into `~/.local/share`:

```bash
wget https://solidcommunity.au/installers/keypod.tar.gz -O keypod.tar.gz
tar zxvf keypod.tar.gz -C ${HOME}/.local/share/
```

These two steps can also be repeated to **update** your installation.

Set up a link to the binary to be able to run the `rattle` command
from a terminal:

```bash
ln -s ${HOME}/.local/share/keypod/keypod ${HOME}/.local/bin/keypod
```

Then set up your local installation (only required once) to make it
known to GNOME and KDE, with a desktop icon for your desktop:

```bash
wget https://raw.githubusercontent.com/anusii/keypod/dev/installers/keypod.desktop -O ${HOME}/.local/share/applications/keypod.desktop
sed -i "s/USER/$(whoami)/g" ${HOME}/.local/share/applications/keypod.desktop
mkdir -p ${HOME}/.local/share/icons/hicolor/256x256/apps/
wget https://github.com/anusii/keypod/raw/dev/installers/keypod.png -O ${HOME}/.local/share/icons/hicolor/256x256/apps/keypod.png
```

**System Install**

To install for any user on the computer begin by downloading the
**.tar.gz** and installing that into `/opt/` or wherever your system
suggests optional installations live:

```bash
wget https://solidcommunity.au/installers/keypod.tar.gz
sudo tar zxvf keypod.tar.gz -C /opt/
```

Those two steps can also be repeated to **update** your installation.

Then set up your local installation (only required once):

```bash
sudo ln -s /opt/keypod/keypod /usr/local/bin/keypod
sudo mkdir -p /usr/local/share/applications/
sudo wget https://raw.githubusercontent.com/gjwgit/rattleng/dev/installers/keypod.desktop -O /usr/local/share/applications/keypod.desktop
sudo wget https://github.com/gjwgit/rattleng/raw/dev/installers/keypod.png -O /opt/rattleng/keypod.png
``` 

If installing somewhere other than`/opt/` you will need to modify the
steps and edit the `rattle.desktop`.

Once installed users can run the app from the GNOME desktop through
the Window key then type `rattle`.

### Snap Install - UNDER DEVELOPMENT

+ Install keypod with `snap install --dangerous keypod.snap`

The *dangerous* refers to side-loading the app from outside of the
snap store. This will not be required for the snap store version but
for this development version we are side-loading the package.

## MacOS

### Zip Install

```bash
wget https://access.togaware.com/keypod-macos.zip
```

Unzip and run keypod.

### Dmg Install - UNDER DEVELOPMENT

The package file `keypod.dmg` can be installed on MacOS. Download
the file and open it on your Mac. Then, holding the Control key click
on the app icon to display a menu. Choose `Open`. Then accept the
warning to then run the app. The app should then run without the
warning next time.

## Web -- No Installation Required

No installer is required for a browser. Simply visit https://keypod.solidcommunity.au. 

Also, your Web browser will provide an option in its menus to install
the app locally, which can add an icon to your home screen to start
the web-based app directly.

## Windows

### Prerequisite

### Zip Install

```bash
wget https://access.togaware.com/keypod-windows.zip
```

Unzip and run `keypod.exe`. You can add the unzipped path to the
system PATH environment variable.

### Inno Install - UNDER DEVELOPMENT 

Download and run the `keypod.exe` to self install the app on
Windows.

### Msix Install - UNDER DEVELOPMENT

+ Download https://access.togaware.com/keypod.msix
+ Add the keypod certificate to your store:
  + Right click the downloaded file in Explorer
  + Choose *Properties*
  + Choose the *Digital Signatures* tab. 
  + Highlight the *Togaware* line
  + Click *Details*. 
  + Click *View Certificate...* 
  + Click *Install Certificate...*
  + Choose *Local Machine*
  + Click *Next*
  + Choose *Place all certificates in the following store*
  + Click *Browse...*
  + Select **Trusted Root Certification Authorities**
  + Click *OK*
  + Click *Next* and *Finish*.
  + A popup says **The import was successful**
+ Open the downloaded `keypod.msix` to install and run keypod
  + Or in PowerShell: `Add-AppxPackage -Path .\keypod.msix`

# GIT LFS NOTE:

- Installers were tracked using [Git LFS](https://git-lfs.com/), please
  follow [this
  instruction](https://docs.github.com/en/repositories/working-with-files/managing-large-files/installing-git-large-file-storage)
  to install it (`apt-get install git-lfs` works on Ubuntu/Debian).

- To track a new file type using Git LFS, e.g. `*.psd` files, run `git
  lfs track "*.psd"` which adds a line in `.gitattributes`, commit the
  changes in `.gitattributes` and then use `git add/commit/push` to
  track large files as you would normally do for small text files.

- To see files tracked by Git LFS, use `git lfs ls-files`, and to see
  the pointer files stored in the Git repository for the LFS tracked
  files, e.g. `keypod.apk`, type `cd ./keypod; git show
  HEAD:installers/keypod.apk`

- For further details of migrating large files in a repository to Git
  LFS, see [this GitHub
  documentation](https://docs.github.com/en/repositories/working-with-files/managing-large-files/moving-a-file-in-your-repository-to-git-large-file-storage).
