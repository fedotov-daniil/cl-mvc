;;;; Created on 2011-05-31 14:46:54
(in-package :todotree-model)

;
;Help functions
;

(defun not-nil-keys (plist &optional result)
  (flet ((keyword-to-symbol (keyword)
           (if (keywordp keyword)
               (intern (symbol-name keyword))
               keyword)))
    (alexandria:doplist (key value plist result)
                        (when value
                          (push (keyword-to-symbol key) result)))))
(defun hash-password (password)
  (ironclad:byte-array-to-hex-string 
   (ironclad:digest-sequence 
    :md5
    (ironclad:ascii-string-to-byte-array password))))

;
; Context
;
(defun add-context (name user-id &optional description)
  (create-instance 'context :name name :user-id user-id :description description))
(defun update-context (id &rest params &key name description)
  (save-slots (make-instance 'context :id id :name name :description description) 
              (not-nil-keys params nil)))
(defun delete-context (id)
  (destroy-instance 'context id))
;
; Tag
;
(defun add-tag (name user-id &optional color picture tab-id)
  (create-instance 'tag :name name :user-id user-id :color color :picture picture :tab-id tab-id))
(defun update-tag (id &rest params &key name color picture tab-id)
  (save-slots (make-instance 'tag :id id :name name :color color :picture picture :tab-id tab-id) 
              (not-nil-keys params nil)))
(defun delete-tag (id)
  (destroy-instance 'tag id))

;
; Note
;
(defun add-note (text user-id &optional color task-id tab-id)
  (create-instance 'note :text text :user-id user-id :color color :task-id task-id :tab-id tab-id))
(defun update-note (id &rest params &key text color task-id tab-id)
  (save-slots (make-instance 'note :id id :text text :color color :task-id task-id :tab-id tab-id) 
              (not-nil-keys params nil)))
(defun delete-note (id)
  (destroy-instance 'note id))

;
; Task
;
(defun add-task (name user-id &optional priority description started active date-due parent-task-id tab-id color)
  (create-instance 'task 
                   :name name  
                   :user-id user-id
                   :priority (or  priority :normal) 
                   :description (or description "") 
                   :date-add (clsql:get-time)
                   :date-start (if started (clsql:get-time))
                   :date-due date-due 
                   :parent-task-id (or parent-task-id 0) 
                   :tab-id tab-id
                   :color color
                   :active active))
(defun update-task (id &rest params &key name priority description started active completed date-due parent-task-id tab-id color)
  (save (update-slots (fetch 'task id)
                            params)))

(defun update-slots (instance slots)
  (alexandria:doplist (key val slots)
                      (let ((func (find-symbol (concatenate 'string (symbol-name (type-of instance)) "-" (symbol-name key)))))
                        (when (and func (fboundp func)) 
                          (funcall (fdefinition (list 'setf func)) val instance))))
  instance)

(defun delete-task (id)
  (destroy-instance 'task id))

;
; User
;
(defun add-user (email password 
                       &optional first-name last-name 
                       &key password-hashed)
  (create-instance 'user 
                   :email email 
                   :password (if password-hashed 
                                 password 
                                 (hash-password password)) 
                   :first-name first-name 
                   :last-name last-name))
(defun update-user (id &rest params 
                       &key email password first-name last-name)
  (save-slots (update-slots (fetch 'user id)
                            params)
              (not-nil-keys params nil)))
(defun delete-user (id)
  (destroy-instance 'user id))

;
; Tab
;
(defun add-tab (name type user-id &key date sort-order)
  (create-instance 'tab 
                   :name (or name 
                             (string-capitalize (symbol-name type))) 
                   :type type 
                   :date date 
                   :sort-order (or sort-order 0) 
                   :user-id user-id))
(defun update-tab (id &rest args &key name type date sort-order)
  (save-slots (update-slots (fetch 'tab id)
                            params)
              (not-nil-keys params nil)))
(defun delete-tab (id)
  (destroy-instance 'tab id))
  