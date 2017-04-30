(load "compiler.scm")

(for-each show-fn (compiler '(mov rax 42)))
