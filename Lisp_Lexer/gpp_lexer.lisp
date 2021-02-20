; ******************************
; *  341 Programming Languages *                
; *  Fall 2020                 *     
; *  Student: Doruk ERGÜN      * 
; *  Number: 171044057         *             
; ******************************

;;GLOBAL VARIABLES
(setq keywords '("AND" "OR" " NOT" "EQUAL" "LESS" "NIL" "LIST"
"APPEND" "CONCAT" "SET" "DEFFUN" "FOR" "IF"
"EXIT" "LOAD" "DISP" "TRUE" "FALSE"))
(setq operators '("+" "-" "/" "*" "(" ")" "**" "\"" ","))
(setq operator_names '("PLUS" "MINUS" "DIV" "MULT" "OP" "CP" "DBLMULT" "C" "COMMA"))

;;UTILITY FUNCTIONS
;;Reads the file
(defun read-the-gpp-file(filename)
    ;;This function reads the whole file named filename character by character and returns the character list.
    (with-open-file (s filename)
    (loop for c_last = (read-char s nil)
            while c_last
            collect c_last)))

;;Checks if the given item is in given sequence
(defun contains (item sequence)
    (setq index 0)
	(loop for piece in sequence do
		(if (equal (string-upcase item) piece)
			(return-from contains index)
		)
        (incf index)
	)
	(return-from contains nil))

;Helps the file writing
(defun writeToFile (name content)
  (with-open-file (stream  name :external-format charset:iso-8859-1
                           :direction :output
                           :if-exists :append
                           :if-does-not-exist :create )
  (format stream content)
  (format stream "~%")
  )
name)

;;Tokenizes the file with some rules, in order to make the DFA work
(defun lexer (file)
    ;;This function looks every character returned from function read-the-gpp-file,
    ;;If the returned character is not space , newline etc it starts pushing the characters to a list named last_word,
    ;;Then pushes the words to a bigger token list, returns that.(
    (setq terminate_word #\?)
    (setq file (append file (list terminate_word)))
    (setq fl '())
    (setq last_word '())

    (setq comment_seen nil)
    (setq newline_seen nil)

    (setq last_char nil)

    (loop for char in file do
        (progn

            (if (not (equal char #\NewLine))
                (setq newline_seen nil)
            )

            (if (and (equal char #\;) (equal last_char #\;))
                (progn 
                (setq comment_seen t)
                (setq comms (coerce "COMMENT" 'list))
                (setq fl (append fl (list comms)))
            ))

            (if (and (equal char #\NewLine) (equal comment_seen t))
                (progn 
                (setq comment_seen nil)
                (setq newline_seen t)
                )
            )

            (if (and (eq t comment_seen) (eq nil newline_seen))
                (progn 
                )
                (progn 
                    
                    (if (or (equal char #\Space ) (equal char #\NewLine ) (equal char #\Tab ) (equal char #\() (equal char #\)) (equal char #\?) )
                        (if (not (equal nil last_word))
                            (progn
                                (setq fl (append fl (list last_word)))
                                (setq last_word '()))))

                    (if (and (not (equal char #\Space)) (not (equal char #\NewLine)) (not (equal char #\Tab)) (not (equal char #\?)) (not (equal char #\;)))
                        (setq last_word (append last_word (list char))))

                    (if (or (equal char #\Space ) (equal char #\NewLine ) (equal char #\Tab ) (equal char #\( ) (equal char #\)) (equal char #\?) )
                        (if (not (equal nil last_word))
                            (progn
                                (setq fl (append fl (list last_word)))
                                (setq last_word '()))))
                )
            )
            

        )
        (setq last_char char)
    )    

    ;;Fixes the format error \# 
    (loop for i from 0 to (- (length fl) 1)
        do(setf (nth i fl) (format nil "~{~A~}" (nth i fl)))
    )

    (return-from lexer fl))

;;Traverses the list, changes states if the token changes its form.
(defun DFA (list)
    ;;Prints the tokens
    (loop for token in list do
    (progn
            (cond   
                ;;Comment
                ((equal token "COMMENT") (writeToFile "parsed_lisp.txt" token))
                ;;Operators
                ((not (eq nil (contains token operators)))(progn (setq current_token (concatenate 'string "OP_" (nth (contains token operators) operator_names)))(writeToFile "parsed_lisp.txt"  current_token)))
                ;;Keywords
                ((not (eq nil (contains token keywords)))(progn (setq current_token (concatenate 'string "KW_" (string-upcase token)))(writeToFile "parsed_lisp.txt" current_token)))
                ;;Some extra information about values.
                ((or(equal token "0")(and (char>=(char token 0) #\1) (char<=(char token 0) #\9))) 	(progn	
																						(setq control 0)
																						(loop for k from 1 to (- (length token) 1 )
																							do(progn
																									(if(or (and (char>=(char token k) #\a)(char<=(char token k) #\z))(and (char>= (char token k) #\A) (char<= (char token k) #\Z))(equal (char token k) #\_) )
																										(progn
																											(setq control 1)
																										)
																									)
																							)
																						)
																						(if(= control 0)
																							(writeToFile "parsed_lisp.txt" (string "VALUE"))
																							(writeToFile "parsed_lisp.txt" (string "ERROR")))))
                ;;Identifiers
                ((and (or (and (char>= (char token 0) #\a) (char<= (char token 0) #\z))(and (char>= (char token 0) #\A) (char<= (char token 0) #\Z))(equal (char token 0) #\_) ) (not (eq token "COMMENT")))(writeToFile "parsed_lisp.txt" (string"IDENTIFIER")))
                ;;Values
                ((equal token "0") (writeToFile "parsed_lisp.txt" (string "VALUE")))
                ((and (char>= (char token 0) #\1) (char<= (char token 0) #\9)) (writeToFile "parsed_lisp.txt" (string "VALUE")))
                ;;Other things
                (t (writeToFile "parsed_lisp.txt" (string "ERROR")))))))

(defun gppinterpreter (&optional (args nil))
    (setq code nil)
    (if args
        (progn 
            (setq code (read-the-gpp-file (car args)))
            (DFA (lexer code)))

        (loop for line = (read-line nil 'eof) until (equal line "") do
            (DFA (lexer (coerce line 'list))))
    )
)

(gppinterpreter *args*)
