# Modular App
This project contains a basic modular iOS app that it's meant to be easily extended in its features.

## Environment setup and first checkout

This project requires Mise to work.
Install it using the regular method, Homebrew is not supported:

```sh
curl https://mise.run | sh
```


Also make sure to activate Mise in your shell by adding the following lines to your shell configuration files.  
You can do this with these commands:

```sh
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
```

To make sure you have the latest version of Mise installed, run:

```sh
mise self-update
```

When you first checkout the repo, you will need to manually trust the .mise.toml file with 

```sh
mise trust
```

## Usage

There are multiple commands that can be ran through Mise. To get a list of them, run

```sh
mise r
```

and select manually the command you need.