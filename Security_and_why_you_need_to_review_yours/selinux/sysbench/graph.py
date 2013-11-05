#!/usr/bin/env python2.6

# Copyright 2013 Percona LLC and/or its affiliates

import numpy
import pylab

def main():
    #set font and other shiny things
    font = {'fontname':'sans-serif','fontsize':14}

    data = { 'ON': 
               { 1 : 37.38,
                 2 : 238.44,
                 4 : 331.62,
                 8 : 225.59,
                 16: 218.12,
                 32: 159.30 },
             'OFF':
               { 1 : 40.49,
                 2 : 269.76,
                 4 : 342.77,
                 8 : 359.75,
                 16: 243.41,
                 32: 359.79 }}
    x = [1,2,4,8,16,32]
    pylab.xticks(x)
    for i in data:
        dset = []
        for res in data[i]:
            dset.append(data[i][res])
        pylab.plot(x, dset, label="Selinux %s" % i)
    
    pylab.savefig("results.png",dpi=200)
    pylab.clf()


if __name__ == '__main__':
  main()
    
