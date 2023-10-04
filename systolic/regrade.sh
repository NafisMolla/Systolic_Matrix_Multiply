#!/bin/zsh

make clean
git stash
git checkout -f master
git pull --no-edit origin master

git checkout -f grading_a
make clean
git pull --no-edit origin master
./grade.sh > autograde.a.txt 2&>1 | cat
git add grade_a.csv
git commit -a -m "grading a done"
git push origin grading_a

git checkout -f grading_b
git stash
make clean
git pull --no-edit origin master
./prep_board.sh > autograde.b-prep.txt 2&>1 | cat
git add autograde.b-prep.txt
git commit -a -m "grading b-prep done"
git push origin grading_b

git checkout -f grading_b
git stash
./grade_board_fast.sh > autograde.b-fast.txt 2&>1 | cat
git add autograde.b-fast.txt
git add grade_b.csv
git commit -a -m "grading b-fast done"
git push origin grading_b

git checkout -f grading_c
git stash
git pull --no-edit origin master
make clean
./prep_bonus.sh > autograde.c-prep.txt 2&>1 | cat
git add autograde.c-prep.txt
git commit -a -m "grading c-prep done"
git push origin grading_c

git checkout -f grading_c
git stash
./grade_bonus_fast.sh > autograde.c-fast.txt 2&>1 | cat
git add autograde.c-fast.txt
git add grade_c.csv
git commit -a -m "grading c-fast done"
git push origin grading_c

git checkout -f master;
git checkout -f grading_a -- grade_a.csv; cat grade_a.csv > grade.csv; 
git checkout -f grading_b -- grade_b.csv; cat grade_b.csv >> grade.csv;
git checkout -f grading_c -- grade_c.csv; cat grade_c.csv >> grade.csv;
git add grade.csv
git commit -a -m "grading done"
git push origin master
