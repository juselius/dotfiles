(application_expression
  (long_identifier_or_op
    (identifier) @injection.language)
  (const
    (triple_quoted_string 
      (format_triple_quoted_string) @injection.content)))

; For Fable `JSX.html`
(application_expression
  (long_identifier_or_op
    (long_identifier
      (identifier)
      (identifier) @injection.language))
  (const
    (triple_quoted_string 
      (format_triple_quoted_string) @injection.content)))

