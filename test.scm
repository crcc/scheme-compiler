(load "compiler.scm")

(emit-program
  (compiler
      '((mov rax 42)
        (mov rax 19))))
