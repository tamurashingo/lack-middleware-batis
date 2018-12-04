#|
  This file is a part of lack-middleware-batis project.
  Copyright (c) 2017-2018 tamura shingo (tamura.shingo@gmail.com)
|#

#|
  lack-middleware-batis integrates Cl-Batis seamlessly with Clack

  Author: tamura shingo (tamura.shingo@gmail.com)
|#

(in-package :cl-user)
(defpackage lack-middleware-batis-asd
  (:use :cl :asdf))
(in-package :lack-middleware-batis-asd)

(defsystem lack-middleware-batis
  :version "0.1"
  :author "tamura shingo"
  :license "MIT"
  :depends-on (:cl-batis
               :cl-dbi-connection-pool)
  :components ((:module "src"
                :components
                ((:file "lack-middleware-batis"))))
  :description "lack-middleware-batis integrates Cl-Batis seamlessly with Clack"
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op lack-middleware-batis-test))))
