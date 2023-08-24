(TeX-add-style-hook
 "udt"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("apa6" "man" "apacite" "draftfirst")))
   (TeX-run-style-hooks
    "latex2e"
    "abstract"
    "introduction"
    "methods"
    "results"
    "discussion"
    "apa6"
    "apa610"
    "amsmath"
    "float"
    "graphicx"
    "mathrsfs")
   (LaTeX-add-bibliographies
    "bibs/cdl"
    "bibs/cdl_2"
    "bibs/crossley"))
 :latex)

