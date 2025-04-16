#!/bin/bash
state=$(amixer -D pulse sget Master | awk '/\[on\]/{print "unmute"; exit} /\[off\]/{print "mute"; exit}')
if [ "$state" = "[on] "]; then 
  amixer 

