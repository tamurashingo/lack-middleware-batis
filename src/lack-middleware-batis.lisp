(in-package :cl-user)
(defpackage lack.middleware.batis
  (:use :cl))
(in-package :lack.middleware.batis)

(cl-syntax:use-syntax :annot)

@export
(defparameter *lack-middleware-batis*
  (lambda (app connection-pool)
    (lambda (env)
      (let ((session (batis:create-sql-session connection-pool)))
        (setf (getf env :lack.batis) session)
        (prog1
            (funcall app env)
          (batis:close-sql-session session))))))

