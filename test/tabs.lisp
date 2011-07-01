;;;; Created on 2011-06-05 15:03:31
(in-package :todotree)
(defcontroller :tabs 
  :options ((:use :todotree :todotree-model) 
            (:import-from :todotree :user-id :*user*)) 
  :view-type :json 
  :view-layout "index")
(in-package :tabs)
(defilter #'todotree::load-user :before)
(defaction content (id) ()
  (let ((tasks (if (string-equal "unsorted" id) 
                   (get-unsorted-tasks (user-id)) 
                   (get-tab-tasks (fetch 'tab id)))))
    (make-view (list :user todotree::*user* 
                     :tasks tasks) 
               :type :partial 
               :name "tab")))
(defaction create () (:view-type :json)
  (let ((tab (create-tab (hunchentoot:parameter "name") 
                         (hunchentoot:parameter "type") 
                         (user-id) 
                         (clsql:parse-date-time (hunchentoot:parameter "date")))))
    (if tab
        (make-view (list :id (id tab) 
                         :name (tab-name tab)))
        (make-view))))
(defaction delete-action (id) (:view-type :json)
  (todotree-model:delete-tab id)
  (make-view (list :id id)))