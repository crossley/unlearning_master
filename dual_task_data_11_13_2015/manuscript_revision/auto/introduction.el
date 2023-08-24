(TeX-add-style-hook
 "introduction"
 (lambda ()
   (LaTeX-add-labels
    "fig:test_cats"
    "fig:models"
    "fig:unlearning_data"))
 :latex)

