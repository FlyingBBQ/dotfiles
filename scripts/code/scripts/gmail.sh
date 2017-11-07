#!/bin/bash

# Username and password
source ~/code/scripts/.creds.sh
USER=$username
PASS=$password

# location of .xml file to curl feed
xmlfile=~/.mutt/newmail.xml

while true; do
        # make a .xml.old file to keep track of read mails
        if [ ! -e $xmlfile ]; then
                touch $xmlfile
        else
                mv $xmlfile $xmlfile.old
                touch $xmlfile
        fi

        # get the .xml feed of gmail and put it in the location of $xmlfile
        curl -su $USER:$PASS https://mail.google.com/mail/feed/atom > $xmlfile

        # get the number of unread emails in inbox for the new and .old .xml file
        new=$(xml sel -N my=http://purl.org/atom/ns# -t -m my:feed -v my:fullcount < $xmlfile)
        old=$(xml sel -N my=http://purl.org/atom/ns# -t -m my:feed -v my:fullcount < $xmlfile.old)

        # check if there are new emails compared to last change
        if (( $new > $old )); then
                # get the authors and titles of the unread emails
                author=$(xml sel -N my=http://purl.org/atom/ns# -t -m my:feed -m my:entry -m my:author -v my:name -o "|" < $xmlfile)
                title=$(xml sel -N my=http://purl.org/atom/ns# -t -m my:feed -m my:entry -v my:title -o "|" < $xmlfile)

                # parse them into an array
                IFS='|' read -r -a arr_author <<< "$author"
                IFS='|' read -r -a arr_title <<< "$title"

                # display the newest email
                notify-send "${arr_author[0]} (new email)" "${arr_title[0]}" -i /home/derek/images/icons/gmail.png

                # Sound notification
                mpv ~/music/notification/next_ep.ogg --volume 70 

                # iterate through the unread emails and make the notification
                # for ((I=1; I < ${#arr_title[*]} ; I++)); do
                        # notify-send "${arr_author[$I]}" "${arr_title[$I]}" -i /home/derek/images/icons/gmail.png 
                # done
        fi
        # Execute every 10 seconds (sleep 10)
        sleep 10
done
