; Inject info Sql.query """SELECT * FROM table""" as sql
((application_expression
  (dot_expression
    base:  (long_identifier_or_op) @module (#eq? @module "Sql")
    field: (long_identifier_or_op) @name   (#eq? @name "query"))
  (const
    (triple_quoted_string) @injection.content))
  (#set! injection.language "sql"))
