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