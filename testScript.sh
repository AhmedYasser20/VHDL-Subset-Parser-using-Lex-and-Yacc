#!/bin/bash
make parser

for n in {1..6}; 
do
    echo "Test Case : "$n
    ./parser < testCases/testcase$n.text
done

