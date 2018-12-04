#|
  This file is a part of lack-middleware-batis project.
  Copyright (c) 2017-2018 tamura shingo (tamura.shingo@gmail.com)
|#

(in-package :cl-user)
(defpackage lack-middleware-batis-test-asd
  (:use :cl :asdf))
(in-package :lack-middleware-batis-test-asd)

(defsystem lack-middleware-batis-test
  :author "tamura shingo"
  :license "MIT"
  :depends-on (:lack-middleware-batis
               :lack-middleware-connection-pool
               :lack
               :lack-test
               :lack-request
               :cl-syntax
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "lack-middleware-batis"))))
  :description "Test system for lack-middleware-batis"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
