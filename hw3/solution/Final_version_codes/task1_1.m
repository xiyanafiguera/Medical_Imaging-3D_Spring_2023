clc;
clear;


[v, f] = read_vtk('/Users/xiyana/Downloads/med-course/homeworks/hw3/input_data/lh.white.vtk');
H = load('/Users/xiyana/Downloads/med-course/homeworks/hw3/input_data/lh.white.H.txt');

write_property('/Users/xiyana/Downloads/med-course/homeworks/hw3/created/lh.white.H.vtk', v, f, struct('H', H));

