;;;; Created on 2011-06-02 14:06:06
(in-package :todotree)
(defcontroller :index :options ((:use :todotree :todotree-model) (:import-from :todotree :user-id :*user*)) :view-type :html :view-layout "index")
(in-package :index)
(defilter #'todotree::load-user :before)
(defaction index () ()
  (let ((tabs (get-tabs (user-id))))
    (make-view  (list :user todotree::*user* :tabs tabs) :name "index")))
(defaction js (file-name) ()
  (make-pathname :directory "views/js/" :name file-name :type "js"))
(defun list-concat (list &optional delimiter)
  (reduce (lambda (a b)
            (concatenate 'string a delimiter b))
          (remove-if-not #'stringp list)))
(defaction style (file-name) ()
  (write-to-string file-name)
  (concatenate 'string "views/css/" (list-concat file-name "/"))
  (pathname (concatenate 'string "views/css/" (list-concat file-name "/"))))



    