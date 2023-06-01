#!/usr/bin/perl
use strict;

my %h;
while(<>){
        if (m/^@/){
            # Header    
            print $_;       
        } else {
            my @x = split /\t/;
            push @{$h{$x[0]}},$_; 
            my $c = scalar(@{$h{$x[0]}});
            if ($c==2){
                print @{$h{$x[0]}};
                delete($h{$x[0]});
            }    
        }
}


