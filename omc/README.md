# Workstation Bootstrap

## Install zsh

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fcmiranda/.omc/refs/heads/main/omc/sh/zsh.sh)"
```

## Install omc repo

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fcmiranda/.omc/refs/heads/main/omc/sh/omc.sh)"
```



## Install US International locale

```sh
cd && ./omc/sh/us-intl-locale.sh
```

## Install packages (kanshi, atuin)

```sh
chmod +x ~/omc/pkgs/install.zsh
cd && ~/omc/pkgs/install.zsh
```

## Install zsh plugins
```sh
chmod +x ~/omc/pkgs/zsh-plugins.zsh
cd && ~/omc/pkgs/zsh-plugins.zsh
```