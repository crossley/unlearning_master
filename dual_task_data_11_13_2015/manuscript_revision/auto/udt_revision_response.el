(TeX-add-style-hook
 "udt_revision_response"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "10pt" "a4paper")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "amsmath"
    "parskip"
    "graphicx"
    "float")
   (LaTeX-add-bibliographies
    "sample"))
 :latex)

