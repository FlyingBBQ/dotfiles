#!/bin/sh

i3lock                      \
\
--timecolor=ebdbb2ff        \
--datecolor=ebdbb2ff        \
--verifcolor=ebdbb2ff        \
--wrongcolor=ebdbb2ff        \
\
--insidecolor=282828ff      \
--ringcolor=fe8019ff        \
--keyhlcolor=458588ff       \
--bshlcolor=cc241dff        \
--insidevercolor=458588ff   \
--insidewrongcolor=cc241dff \
--ringvercolor=83a598ff     \
--ringwrongcolor=fb4934ff   \
--line-uses-inside          \
\ #--linecolor=665c54ff        \
\
--screen 0                  \
--blur 5                    \
--clock                     \
--indicator                 \
\
--datestr="%A, %b %d"       \
--timestr="%H:%M"           \
\
--wrongtext="Nope!"         \
--show-failed-attempts
