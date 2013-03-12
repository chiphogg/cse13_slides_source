# Animated Uncertainty talk slides

This repository should let you build my talk slides from the CSE13 conference.
Check out [the finished product](http://bit.ly/SmoothAni) to see what you
should get.

**If you experience any problems, please let me know!** It could be easy for me
to fix them -- and anyway, I'll want to update these instructions!

A major long-term goal of mine is to improve the workflow for making these kind
of slides.  It's amazing what we can do with HTML5, CSS, javascript, and
R-markdown -- but it's still not nearly frictionless enough, and we're **not**
taking advantage of HTML5 figures (e.g., d3.js and MathBox.js) the way we
should be able to.

# Steps to reproduce the slides

## Preamble: set up a recent version of R

You need to have `R` installed, and it needs to be version 2.15 or greater.
To check your version of `R`, run the following at the command prompt:
```sh
R --version | head -1
```

### Setup packages

**Disclaimer**: I haven't actually run these steps on a fresh install of `R`.

  1. `devtools`
    - A handy tool to grab the latest-and-greatest version of actively
      developed packages.  Install this first, by running the following command
      in `R`:
      ```r
      install.packages('devtools')
      ```

  2. `slidify`
    - This is the library that makes the slides.
      [The instructions](http://ramnathv.github.com/slidify/start.html)
      are as follows:
      ```r
      library(devtools)
      install_github('slidify', 'ramnathv')
      install_github('slidifyLibraries', 'ramnathv')
      ```

  3. Other libraries
    ```r
    install.packages(c('gppois', 'reshape2', 'ggplot2', 'Cairo'),
      dependencies=TRUE)
    install_github(username='yihui', repo='knitr')
    ```

## Generate the slides

**NOTE**: The first run will take a _really_ long time -- it could easily be an
hour, or more.

If you've got that kind of time, go to a bash prompt in the base directory and
type:

```sh
./run
```

Subsequent runs are much faster, due to caching.

