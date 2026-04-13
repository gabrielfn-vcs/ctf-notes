#!/bin/sh

# Provide the input emoji sequence
emojis="🕯️🕷️🧟🎃🌕💀🧛🕸️👻🕯️"

# Pass the emoji sequence as input to the Java program
# The `echo` command sends the emojis into the Java program after it's prompted for input
#echo "$emojis" | java TCUP
echo "$emojis" | sudo java -cp /opt TCUP
