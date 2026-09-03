+++
title = '{{ replace .File.ContentBaseName "-" " " | title }}'
date = {{ .Date }}
# Reihenfolge in der Seitenleiste — kleinere Zahl steht weiter oben.
weight = 10
# Schlagwörter tauchen unter /tags/ auf.
tags = []
# Auf true setzen, solange die Seite nicht veröffentlicht werden soll.
draft = false
+++
