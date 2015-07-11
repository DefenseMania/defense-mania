#!/bin/bash

cd shared/code

rm ../../android/data
rm ../../desktop/data
rm ../../browser/data

ln -s ../shared/data ../../android/data
ln -s ../shared/data ../../desktop/data
ln -s ../shared/data ../../browser/data


FILES=*
for f in $FILES
do
  rm ../../android/$f
  rm ../../desktop/$f
  rm ../../browser/$f
  ln -s ../shared/code/$f ../../android
  ln -s ../shared/code/$f ../../desktop
  ln -s ../shared/code/$f ../../browser
done