+++
title = '{{ replace .File.ContentBaseName "-" " " | title }}'
date = {{ .Date }}
type = 'chapter'
weight = 10
+++

Kurze Beschreibung, worum es in diesem Kapitel geht.

{{%/* children depth="2" description="true" */%}}
