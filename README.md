# phonebook-for-KIM-1
Found in Hobbycomputer #1
(c) 1980 Herwig Feichtinger 
improved by Nils Andreas 

a phonebook ... silly, but it's there

![phonebook](https://github.com/netzherpes/phonebook-for-KIM-1/raw/main/phonebook..png)

It simply saved lines of text from 0200 or 2000 on, depending on the version. <br>
The interesting part is the search function, where you can querry a phrase, a name, a number and the program will spit out the line of text containing this phrase.

## Versions
The small (original) version is unusable meanwhile, as I cannot send a NUL on modern terminals (or at least I did not figure out how :D ). So I came up with a workaround, that adds a #$00 after the last entry, changed the memory layout, added some text in the beginning. Nothing thrilling, but for me a huge step in the learning curve.

original version: Load $00, Start $77, Data at $0200<br>
improved version: Load $0200, Start $0200, Data at $2000

## Usage 
Switch Data entry / data query with (ESC) <br>
The Program starts in data query mode and a question mark. Enter a searchphrase or press (ENTER) to show all entries.<br>
*The first letter after the (ESC) is sadly not echoed. Still investigating. Stoopid KIM. But it's there ;)*

After switching to data entry you can write whatever you want, up to 255 characters. Normally (in a phonebook) something like
 > nils 0190222222

End your line with (ENTER). **Important: Start your very first enrty with an (Enter), too!**<br>
Ater you are finished, press (ESC)  to get back to search for entries. 

## Memory of Data
The single entries are identified by the $0d at the start and the end. Everything in between this borders counts as one line.<br>
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
