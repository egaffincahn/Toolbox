function addpathwithout(add, except)

addpath(genpath(add))
rmpath(genpath(except))