;(websearch-text "xyzzy lisp åüçı google")
;inspired by https://github.com/tomoya/search-web.el/blob/master/search-web.el
(defvar *websearch-search-engines* nil "A list is search engines list. keys engines nick, and value is search engine query.Search word %s. In formatting url-hexify. Use %% to put a single % into output.")
(unless *websearch-search-engines*
  (setf *websearch-search-engines*
        '(("sitepoint" . "http://reference.sitepoint.com/search?q=%s")
          ("google" . "http://www.google.com/search?q=%s")
          ("google ja" . "http://www.google.com/search?hl=ja&q=%s")
          ("google en" . "http://www.google.com/search?hl=en&q=%s")
          ("google maps" . "http://maps.google.co.jp/maps?hl=ja&q=%s")
          ("youtube" . "http://www.youtube.com/results?search_type=&search_query=%s&aq=f")
          ("twitter" . "http://search.twitter.com/search?q=%s")
          ("eijiro" . "http://eow.alc.co.jp/%s/UTF-8/")
          ("amazon" . "http://www.amazon.com/s/url=search-alias%%3Daps&field-keywords=%s")
          ("amazon jp" . "http://www.amazon.co.jp/gp/search?index=blended&field-keywords=%s")
          ("yahoo" . "http://search.yahoo.com/search?p=%s")
          ("yahoo jp" . "http://search.yahoo.co.jp/search?p=%s")
          ("xyzzy-lisp" . "http://xyzzy.s53.xrea.com/reference/wiki.cgi?p=%s")
          ("wikipedia" . "http://www.wikipedia.org/search-redirect.php?search=%s&language=ja")
          ("wikipedia en" . "http://www.wikipedia.org/search-redirect.php?search=%s&language=en")
          ("wikipedia ja" . "http://www.wikipedia.org/search-redirect.php?search=%s&language=ja"))))

(defvar *websearch-last-search-engine* "google")

(defun websearch-make-search-engine-indices ()
  (let ((lst '()))
    (dolist (one-engine *websearch-search-engines*)
      (push (car one-engine) lst))
    lst))
(defun websearch-browse-url(url)
  (shell-execute url t))
(defun websearch-text (&rest lst)
  (let* ((text (nth 0 lst))
         (do-confirm-engine (nth 1 lst))
         (query (si:www-url-encode (map-internal-to-utf-8 text)))
         (engine-idx (if do-confirm-engine
                         (completing-read "Search Engines: "
                                          (websearch-make-search-engine-indices) :default *websearch-last-search-engine* :must-match t)
                       *websearch-last-search-engine*))
         (engine (cdr (assoc engine-idx *websearch-search-engines* :test #'equal)))
         (url (substitute-string engine (regexp-quote "%s") query))
        )
    (setf *websearch-last-search-engine* engine-idx)
    (websearch-browse-url url)))
(defun websearch-onthespot-with-confirm (&rest lst)
  (interactive)
  (websearch-onthespot t))

(add-hook '*post-startup-hook*
        #'(lambda()
            (add-menu-item *app-popup-menu* nil "ëIëîÕàÕÇWebåüçı (&G)"
                 'websearch-onthespot nil)))

(defun websearch-onthespot (&rest lst)
  (interactive)
  (let ((with-confirm (nth 0 lst))
        query-text
        (cand-selection (if (not (= 2 (or (get-selection-type) 0))) nil
                          (string-trim " \n\t" (buffer-substring
                                                (min (selection-mark) (selection-point))
                                                (max (selection-mark) (selection-point))))))
        (cand-region (if (not (mark t)) nil
                       (string-trim " \n\t" (buffer-substring (region-beginning) (region-end)))))
        (cand-word (websearch-onthespot-word))
        )
    (setf query-text
          (cond (cand-selection
                 (substitute-string cand-selection "\n" " "))
                ((and cand-region
                      (not (string-match "\n" cand-region)))
                 cand-region)
                (t
                 cand-word)))
    (websearch-text query-text with-confirm)
    ))

(defun websearch-onthespot-word ()
  (let* ((pos (point))
         p-wk p-b p-f word-onthespot
         )
    (setf p-wk (progn (next-word) (previous-word) (point)))
    (goto-char pos)
    (if (= pos p-wk)
        (setf p-b pos)
      (setf p-b (progn (backward-word) (point)))
      )
    (setf p-f (progn (forward-word) (point)))
    (setf word-onthespot (buffer-substring p-b p-f))
    (goto-char pos)
    ;;(message word-onthespot)
    word-onthespot
    ))


