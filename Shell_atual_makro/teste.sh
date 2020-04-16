#!/bin/bash
sleep 5
ping makro10
sleep 3
while [ $? -eq 0 ]; do
echo "ok!"
if [ $? != 0 ] ; then
echo "mandando email"
else
echo "ok"
fi 
done

