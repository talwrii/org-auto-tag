;;; Copyright Tal Wrii
;;; GPLv3
;;; Maintain a collection of tags and keys to define them.
;;; Usage: map some key to org-auto-tag
;;;  This reads a key
;;;    If the key is associated with a tag then tag with this tag
;;;    If no tag is associated prompted for one
;;;    n reserved for a new tag

(require 'f)

(defvar org-auto-tag-file "~/.emacs.d/autotags" "File in which to store tags")
(defvar org-auto-tag-new-key ?n "Key define a new tag (or override an existing one")

(defun org-auto-tag (key)
  (interactive (list (read-char)))
  (let (mappings tag)
    (setq mappings (org-auto-tag--mappings))
    (setq tag (cdr (assoc key mappings)))
    (cond
     ((equal key org-auto-tag-new-key)
      (org-auto-tag
       (call-interactively 'org-auto-tag-define)))
     ((null tag)
      (progn
        (org-auto-tag-define key)
        (org-auto-tag key)))
     ('t (org-auto-tag-add tag)))))


(defun org-auto-tag--mappings ()
  "Read the current mappings."
  (when (f-exists? org-auto-tag-file)
    (read (f-read org-auto-tag-file))))

(defun org-auto-tag--set-mapping (key value)
  (org-auto-tag--write-mappings (cons (cons key value) (assq-delete-all key (org-auto-tag--mappings)))))

(defun org-auto-tag--write-mappings (mappings)
  "Write MAPPINGS to tag file."
  (message "writing mappings %S" mappings)
  (write-region (prin1-to-string mappings) nil org-auto-tag-file))

(defun org-auto-tag-define (key)
  (interactive (list (read-char "Define tag for key:")))
  (org-auto-tag--set-mapping key (read-string (format "Tag for %c:" key)))
  key)


(defun org-auto-tag-add (tag)
  (org-set-tags-to (cons tag (org-get-tags))))


(provide 'org-auto-tag)





