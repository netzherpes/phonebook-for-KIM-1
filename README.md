# phonebook-for-KIM-1
Found in Hobbycomputer #1
(c) 1980 Herwig Feichtinger 
improved by Nils Andreas 

a phonebook ... silly, but it's there

![phonebook](https://github.com/netzherpes/phonebook-for-KIM-1/raw/main/phonebook..png)

It simply saved lines of text from 0200 or 2000 on, depending on the version. The original Version (start $0077) has some nasty errors though. I tried to fix some things in the improved version (start $0200)<br>
The interesting part is the search function, where you can querry a phrase, a name, a number and the program will spit out the line of text containing this phrase.

## Versions
The small (original) version is, well, not usable anymore, as I cannot send a NUL on modern terminals. So I came up with a workaround, that adds a #$00 after the last entry, changed the memory layout, added some text in the beginning. Nothing thrilling, but for me a huge step in the learning curve.

## Usage 
Switch Data entry / data querry with "esc" <br>
You start with data querry. and a question mark.<br>
The first letter after the (ESC) is sadly not echoed. Still investigating. Stoopid KIM. But it's there ;) 

After switching to data entry you can write whatever you want, up to 255 chars. End your line with (ENTER). **Important: Start your very first enrty with an (Enter), too!**<br>

 > nils 0190222222

after you are finished, press esc to search for entries.

## Memory of Data
The single entries are identified by the $0d at the start and the end. Eberything in between this borders counts ad one line.<br>
The memory should look like the following 
|Location|Content|Why?|
|-|-|-|
|$2000|#$00|start|
|$2001|#$0d|begin of an entry|
|$2002-$2010|some text||
|$2011|#$0d|end and start new entry|
|$2012|#$00|important, as the program searches the first free $00 for the next entry|

To save your data, save from $2000 to the first $00 after $2000 ... will write a sub for this l8r

webdoktor
