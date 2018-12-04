(in-package :cl-user)
(defpackage lack.middleware.batis
  (:use :cl)
  (:export :*lack-middleware-batis*))
(in-package :lack.middleware.batis)

(defparameter *lack-middleware-batis*
  (lambda (app)
    (lambda (env)
      (let ((connection (getf env :lack.db.connection)))
        (if (not (null connection))
            (let ((session (batis:create-sql-session (dbi-cp.proxy:dbi-connection connection))))
              (setf (getf env :lack.db.session) session)
              (handler-bind ((error (lambda ()
                                      (batis:rollback session)
                                      (batis:close-sql-session session))))
                (prog1
                   (funcall app env)
                  (batis:close-sql-session session))))
            (funcall app env))))))
