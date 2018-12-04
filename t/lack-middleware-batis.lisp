(in-package :cl-user)
(defpackage lack.middleware.batis.test
  (:use :cl
        :prove
        :lack
        :lack.test
        :lack.request
        :batis)
  (:shadowing-import-from :lack.test
                          :request))
(in-package :lack.middleware.batis.test)

(cl-syntax:use-syntax :annot)

(plan 1)

;; initialize
(let ((conn (dbi:connect :mysql
                         :database-name "batistest"
                         :username "nobody"
                         :password "nobody")))
  (dbi:do-sql conn "drop table if exists product")
  (dbi:do-sql conn "create table product (id integer primary key, name varchar(20) not null, price integer not null)")
  (dbi:do-sql conn "insert into product (id, name, price) values (1, 'NES', 14800)")
  (dbi:commit conn)
  (dbi:disconnect conn))


@select ("select name, price from product where id = :id ")
(defsql search-product (id))

@update ("update product"
         (sql-set
          (sql-cond (not (null name))
                    " name = :name, ")
          (sql-cond (not (null price))
                    " price = :price "))
         (sql-where
          " id = :id "))
(defsql update-product (id name price))


(subtest "connection pool middleware"
  (let ((app
         (builder
          (:connection-pool
           :driver-name :mysql
           :database-name "batistest"
           :username "nobody"
           :password "nobody")
          :batis
          #'(lambda (env)
              (let* ((req (make-request env))
                     (session (getf env :lack.db.session)))
                `(200
                  (:content-type "text/text")
                  (,(if (eq :post (request-method req))
                        (prog1
                            (update-one session update-product :id 1 :name "SNES" :price 25000)
                          (commit session))
                        (select-one session search-product :id 1)))))))))

    (diag "select")
    (destructuring-bind (stattus headers body)
        (funcall app (generate-env "/"))
      (is body '((:|name| "NES" :|price| 14800))))

    (diag "insert")
    (destructuring-bind (stattus headers body)
        (funcall app (generate-env "/" :method :post)))

    (diag "select count")
    (destructuring-bind (stattus headers body)
        (funcall app (generate-env "/"))
      (is body '((:|name| "SNES" :|price| 25000))))))

(lack.middleware.connection.pool:shutdown)

(finalize)
