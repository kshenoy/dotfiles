#!/usr/local/bin/perl

use strict;
use diagnostics;

# Convert a decimal to a binary
sub dec2bin {
	my $str = unpack("B32", pack("N", shift));
}

# Convert a binary number to a decimal number
sub bin2dec {
	unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
}

# XOR Function
sub myxor {
	return 0 if ($_[0]==$_[1]);
	return 1 if ($_[0]!=$_[1]);
}

# Binary to Gray-Code Converter
sub bin2gray {
	my @bin=split(//,$_[0]);
	
	my @gray;
	$gray[0]=$bin[0];
	for(my $i=1; $i<=$#bin ; $i++){		
		$gray[$i]=myxor($bin[$i],$bin[$i-1]);
	}

	my $graystr=join('',@gray);
}

# Decimal to Gray-Code Converter
sub dec2gray {
	bin2gray(dec2bin($_[0]));
}

my $bini;
my $n;
$n = (32 - $ARGV[1]) if defined $ARGV[1];
for (my $i=0;$i<=$ARGV[0];$i++){
	$bini=dec2bin($i);
	$bini =~ s/^0{$n}//;   # To remove leading zeros
	printf("%6d -> %s\n",$i,$bini);
}
