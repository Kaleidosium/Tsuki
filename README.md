# Tsuki 🈷️

Tsuki is a project template to quickly set up LOVE2D to run [Yuescript](https://github.com/pigpigyyy/yuescript) instead of Lua,
*without* precompiling your `.yue` files to `.lua`

This repository was forked from [novafacing](https://github.com/novafacing)'s [selene](https://github.com/novafacing/selene).

## Table of Contents

- [Tsuki 🈷️](#tsuki-️)
  - [Table of Contents](#table-of-contents)
  - [Installing](#installing)
    - [Install LOVE2D](#install-love2d)
    - [Create Your Game](#create-your-game)
  - [Using](#using)
    - [First Run](#first-run)
    - [Writing Your Game](#writing-your-game)
  - [Building and Testing](#building-and-testing)
    - [Build/Test Dependencies](#buildtest-dependencies)
    - [Testing](#testing)
    - [Release Builds](#release-builds)
      - [Debugging Release Builds](#debugging-release-builds)
  - [Useful Documentation](#useful-documentation)
  - [Contributions and Bug Fixes](#contributions-and-bug-fixes)
  - [Thanks](#thanks)
  - [License](#license)

## Installing

Tsuki works on Linux, macOS and Windows. It should also work anywhere else
that LOVE2D runs!

### Install LOVE2D

Tsuki needs LOVE2D to be installed to run your game, and you can get the installer
for your platform at [the LOVE2D website](https://love2d.org).

### Create Your Game

You have two options when using Tsuki to create your game:

First (and most recommended) is to use this repo as a template repo. To do that, click
the button at the top right of the [github page](https://github.com/kaleidosium/tsuki)
that says "Use this template". That will create a new repo in your account that is a
copy of the Tsuki repo!

Second, is you can directly clone and modify this repo (or a fork of it), or just
download the zip file of this repo.

Once you have decided, just clone this repo (replace the link with your own if you
forked or used it as a template):

```sh
git clone https://github.com/kaleidosium/tsuki.git
```

That's it! The conf.lua and main.lua take care of everything else to allow you to run
the game!

## Using

### First Run

Now that you have the repository set up, just run `love .` to start your game! There is
a demo project already configured for you, and you should see something like this:

![A screenshot of the game running, displaying a moon image on the default LOVE2D dark background](https://github.com/user-attachments/assets/fe8d7fe2-7001-4a0b-83ca-d3b0584a5d40)

and you should be able to move around with the arrow keys.

### Writing Your Game

Now that you're all set up, write your game! Your source code should go in
[the src directory](src/), and you can add as many files as you want.
[The main file](src/Main.yue) gives an example of how to require another file (in this
case `Game.yue`) to make your game's code modular. There is also a `Player` class
and a `Vector2` class to demonstrate how you might make your game even *more* modular.

## Building and Testing

### Build/Test Dependencies

You don't need any dependencies other than `love` to *run* your game, but you will to
build and test it.

You will need a couple dependencies:

- `lua == 5.1`: You can probably install from your package manager i.e.
  `apt install lua5.1`
- `luarocks`: You can probably also install this from your package manager, or you can
  get it [here](https://luarocks.org/#quick-start)
- `act`: For local release builds, you will need to install
  [act](https://github.com/nektos/act)

Once you have `luarocks` installed, you can install the dependencies with:

```sh
luarocks make --dev
```

Don't forget the `--dev`, it's important!

### Testing

There is a build/test script `build.yue` provided that works automatically with the
template repo. You can invoke it to run tests like:

```sh
yue -e build.yue src --test
```

It will run `busted` tests on all files matching a pattern, which defaults to
`Test.+%.yue` but you can provide your own once you start writing your own tests like
so:

```sh
yue -e build.yue src --test --pattern '.+Test%.yue'
```

### Release Builds

Release builds of projects will contain the bare minimum files to run, so for release
all `.yue` files will be compiled to `.lua`, all extra libraries are removed, and a
`.love` or `.exe` is produced. You can produce a release build by running:

```sh
act --artifact-server-path=release
```

This will spin up a pipeline, build your release, and output the files to `release`.

#### Debugging Release Builds

The release build uses `build.yue` to compile all your `.yue` files to `.lua`.
If you have an issue, you can invoke it locally:

```sh
yue -e build.yue src
```

This will display any build errors encountered.

You can clean up the lua files from the source tree with:

```sh
yue -e build.yue src --clean
```

But be aware this will delete *all* `.lua` files in `src`!

## Useful Documentation

- [Love2D Documentation](https://love2d.org/wiki/Main_Page)
- [Yuescript Documentation](https://yuescript.org/)

## Contributions and Bug Fixes

Bug fixes and contributions are welcome! If you find any issues, just open an Issue and I'll
take a look at it. I'm not going to formalize the process too much, because this is a tiny repo
and I don't expect I'll add too much code to it. Any improvements are likewise appreciated!

## Thanks

Thanks for using Tsuki! I hope it helps you create great games, and if you do, please open a PR to
add a gif or screenshot of your game and a link to it to this README so you can show it off!

And special thanks to [novafacing](https://github.com/novafacing) (The creator of [Selene](https://github.com/novafacing/selene))
, [pigpigyyy](https://github.com/pigpigyyy) (The creator of [Yuescript](https://github.com/pigpigyyy/Yuescript))
, [leafo](https://github.com/leafo) (The creator of [MoonScript](https://github.com/leafo/moonscript))
, and various other people who have contributed to the projects this one relies or built on. Without their contributions
, this project would not have existed.

## License

MIT
