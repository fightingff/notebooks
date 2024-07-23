# Bandit

> Learning linux commands and security concepts for fun!

## Level 0

```bash
ssh bandit0@bandit.labs.overthewire.org -p 2220
password: bandit0
```

## Level 0 -> Level 1

```bash
cat readme
password: ZjLjTmM6FvvyRnrb2rfNWOZOTa6ip5If

# du - estimate file space usage
```

## Level 1 -> Level 2

```bash
# - is a special character as argument, representing stdin/stdout
# func1 | func2 - pipe the output of func1 as input to func2
cat ./-
password: 263JGJPfgU6LtdEvgfWU1XP5yac29mFx
```

## Level 2 -> Level 3

```bash
# spaces in filename: escape with '/' or use quotes
cat spaces\ in\ this\ filename
cat "spaces in this filename"
cat spaces*
password: MNk8KNH3Usiio41PRUEoDFPqfxLPlSmx
```

## Level 3 -> Level 4

```bash
# hidden files start with '.'
find . -name "*"
ls -a
password: 2WmrDFRmJIq3IPxneAaMGhap0pFhF3NJ
```

## Level 4 -> Level 5

```bash
# file - determine file type
file inhere/* # will get only one ASCII text file(others are data)
cat inhere/-file07
password: 4oQYVPkxZOOEOO5pTW81FB8j8lxXGUQw
```

## Level 5 -> Level 6

```bash
# find - search for files in a directory hierarchy
find inhere -size 1033c | xargs cat
password: HWasnPhtq9AVKe0dmk45nxy20cvUa6EG
```

## Level 6 -> Level 7

```bash
# find - search for files in a directory hierarchy
find / -user bandit7 -group bandit6 -size 33c 2>/dev/null | xargs cat
password: morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj
```

## Level 7 -> Level 8

```bash
# grep - print lines matching a pattern
grep "millionth" data.txt
password: dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc
```

## Level 8 -> Level 9

```bash
# sort - sort lines of text files
# uniq - report or omit repeated lines
# sort | uniq - sort and remove duplicates
sort data.txt | uniq -u
password: 4CKMh1JI91bUIZZPXDqGanal4xvAg0JM
```

## Level 9 -> Level 10

```bash
# strings - print the strings of printable characters in files
strings data.txt | grep "=="
password: FGUW5ilLVJrxX9kMYMmlN4MgbpfMiqey
```

## Level 10 -> Level 11

```bash
# base64 - base64 encode/decode data and print to standard output
# base64 is a simple encoding scheme that encodes binary data as text, not encryption
base64 -d data.txt
password: dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr
```

## Level 11 -> Level 12

```bash
# tr - translate or delete characters, use array inference to map characters
# tr 'A-Za-z' 'N-ZA-Mn-za-m' - ROT13
tr 'A-Za-z' 'N-ZA-Mn-za-m' < data.txt
password: 7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4
```

## Level 12 -> Level 13

```bash
# xxd - make a hexdump or do the reverse
xxd -r data.txt > data
file data
# data is a gzip compressed data
mv data data.gz
gzip -d data.gz
file data
# data is a bzip2 compressed data
mv data data.bz2
bzip2 -d data.bz2
file data
# data is a gzip compressed data
mv data data.gz
gzip -d data.gz
file data
# data is GNU tar archive
mv data data.tar
tar -xvf data.tar
file data5.bin
# data5.bin is a POSIX tar archive
mv data5.bin data5.tar
tar -xvf data5.tar
# data6.bin is a bzip2 compressed data
mv data6.bin data6.bz2
bzip2 -d data6.bz2
file data6
# data6 is a POSIX tar archive
mv data6 data6.tar
tar -xvf data6.tar
# data8.bin is a gzip compressed data
mv data8.bin data8.gz
gzip -d data8.gz
# data8 is a ASCII text file
cat data8
password: FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn
```

## Level 13 -> Level 14

```bash
# ssh user@host -i keyfile -p port
# gain correct port
cat /etc/ssh/sshd_config
ssh bandit14@localhost -i sshkey.private -p 2220
password: MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS
```

## Level 14 -> Level 15

```bash
# nc - arbitrary TCP and UDP connections and listens
# telnet - user interface to the TELNET protocol
echo "MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS" | nc localhost 30000
telnet localhost 30000
password: 8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo
```