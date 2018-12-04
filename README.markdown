# Lack-Middleware-Batis
[![Build Status](https://travis-ci.org/tamurashingo/lack-middleware-batis.svg?branch=master)](https://travis-ci.org/tamurashingo/lack-middleware-batis)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)

CL-BATIS interface for Lack


## Usage

### initialize

```common-lisp
(lack:builder
  (:connection-pool
   :driver-name :mysql
   :database-name "test"
   :username "root"
   :password "password")
  :batis
  *app*)
```

lack-middleware-connection-pool is need.


### in app

```common-lisp
;; define SQL
@select ("select name, price from product where id = :id")
(defsql search-product (id))

(lambda (env)
  (let ((session (getf env :lack.db.session)))
    (select-one session search-product :id 1)))
```


## Installation

This library will be available on Quicklisp when ready for use.

## Author

* tamura shingo (tamura.shingo@gmail.com)

## Copyright

Copyright (c) 2017-2018 tamura shingo (tamura.shingo@gmail.com)

## License

Licensed under the MIT License.
