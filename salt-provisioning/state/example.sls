/tmp/salt-example.txt:
  file.managed:
    - source: salt://example.txt
    - template: jinja
    - context:
      greeting: {{ pillar['greeting'] }}
