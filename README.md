### WonkoWeb [![Code Climate](https://codeclimate.com/github/02JanDal/WonkoWeb/badges/gpa.svg)](https://codeclimate.com/github/02JanDal/WonkoWeb) [![Test Coverage](https://codeclimate.com/github/02JanDal/WonkoWeb/badges/coverage.svg)](https://codeclimate.com/github/02JanDal/WonkoWeb) [![Build Status](https://travis-ci.org/02JanDal/WonkoWeb.svg?branch=master)](https://travis-ci.org/02JanDal/WonkoWeb) [![Dependency Status](https://gemnasium.com/02JanDal/WonkoWeb.svg)](https://gemnasium.com/02JanDal/WonkoWeb)


This is the result of me derping around with Rails. Be prepared for bad code.

#### Deployment

1. Install docker
2. Make sure you can execute `docker` without sudo
3. `rake docker:up`, this will build all images required and run them.
4. Use `rake -T | grep docker` for more commands