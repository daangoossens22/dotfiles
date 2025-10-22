;; extends

((tag
  (name) @text.note @nospell
  ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#any-of? @text.note "REF"))

("text" @text.note
 (#any-of? @text.note "REF"))

((tag
  (name) @text.warning @nospell
  ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#any-of? @text.warning "SAFETY"))

("text" @text.warning @nospell
 (#any-of? @text.warning "SAFETY"))
