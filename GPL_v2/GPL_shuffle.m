function [cr]=GPL_shuffle(nc,deck)
    [i,cr]=sort(rand(1,deck));cr=cr(1:nc);