(TeX-add-style-hook
 "udt_revised_2GA"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("apa6" "apacite" "draftfirst" "man")))
   (TeX-run-style-hooks
    "latex2e"
    "apa6"
    "apa610"
    "amsmath"
    "float"
    "graphicx"
    "mathrsfs")
   (LaTeX-add-labels
    "fig:test_cats"
    "fig:unlearning_data"
    "fig:models"
    "fig:exc_dual"
    "fig:learning_curves"
    "fig:savings")
   (LaTeX-add-bibliographies
    "bibs/cdl"
    "bibs/cdl_2"
    "bibs/crossley"))
 :latex)

