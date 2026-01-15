#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Std;
use Data::Dumper;

# kill program and print help if no command line arguments were given
if( scalar( @ARGV ) == 0 ){
  &help;
  die "Exiting program because no command line options were used.\n\n";
}

# take command line arguments
my %opts;
getopts( 'hf:m:o:', \%opts );

# if -h flag is used, or if no command line arguments were specified, kill program and print help
if( $opts{h} ){
  &help;
  die "Exiting program because help flag was used.\n\n";
}

# parse the command line
my( $file, $map, $out ) = &parsecom( \%opts );

my %hash; # contains data from $file
my %popmap; # contains data from $map
my %hoa; # hash of arrays; key = popname

my @fileLines;
my @mapLines;

&filetoarray( $file, \@fileLines );
&filetoarray( $map, \@mapLines );

# parse input file
foreach my $line( @fileLines ){
	my @temp = split( /\s+/, $line );
	$hash{$temp[0]} = $temp[1];
}

# parse population map
foreach my $line( @mapLines ){
	my @temp = split( /\s+/, $line );
	$popmap{$temp[0]} = $temp[1];
}

# create array per population
foreach my $ind( sort keys %hash ){
	push( @{$hoa{$popmap{$ind}}}, $hash{$ind} );
}

open( OUT, '>', $out ) or die "Can't open $out: $!\n\n";

print OUT "Pop\tMean\tStDev\tMedian\tMin\tMax\n";
# calculate stats for each pop
foreach my $arr( sort keys %hoa ){
	my $mean = &calcMean( \@{$hoa{$arr}} );
	my $stdev = &calcStdev( \@{$hoa{$arr}}, $mean);
	my $med = &calcMedian( \@{$hoa{$arr}} );
	my $min = &calcMin( \@{$hoa{$arr}} );
	my $max = &calcMax( \@{$hoa{$arr}} );

	$mean = sprintf("%.3f", $mean );
	$stdev = sprintf("%.3f", $stdev );
	$med = sprintf("%.3f", $med );
	$min = sprintf("%.3f", $min );
	$max = sprintf("%.3f", $max );

	print OUT $arr, "\t", $mean, "\t", $stdev, "\t", $med, "\t", $min, "\t", $max, "\n";
}

close OUT;

#print Dumper( \%hoa );

exit;

#####################################################################################################
############################################ Subroutines ############################################
#####################################################################################################

# subroutine to print help
sub help{
  
  print "\nconfusionMatrix.pl is a perl script developed by Steven Michael Mussmann\n\n";
  print "To report bugs send an email to mussmann\@email.uark.edu\n";
  print "When submitting bugs please include all input files, options used for the program, and all error messages that were printed to the screen\n\n";
  print "Program Options:\n";
  print "\t\t[ -h | -f | -m | -o ]\n\n";
  print "\t-h:\tDisplay this help message.\n";
  print "\t\tThe program will die after the help message is displayed.\n\n";
  print "\t-f:\tSpecify the name of the input file.\n";
  print "\t\tThis should be the input file from missingData.sh or seqDepth.sh script.\n\n";
  print "\t-m:\tSpecify a population map (format = sampleName<tab>popName).\n";
  print "\t-o:\tSpecify output file (Optional; default=output.txt).\n\n";
  
}

#####################################################################################################
# subroutine to parse the command line options

sub parsecom{ 
  
  my( $params ) =  @_;
  my %opts = %$params;
  
  # set default values for command line arguments
  my $file = $opts{f} || die "No input file specified (file is probably named missing.txt or depth.txt).\n\n"; #used to specify input file name.
  my $map = $opts{m} || die "No population map specified.\n\n"; #used to specify input file name.
  my $out = $opts{o} || "output.txt"; #used to specify output file name.

  return( $file, $map, $out );

}

#####################################################################################################
# subroutine to put file into an array

sub filetoarray{

  my( $infile, $array ) = @_;

  
  # open the input file
  open( FILE, $infile ) or die "Can't open $infile: $!\n\n";

  # loop through input file, pushing lines onto array
  while( my $line = <FILE> ){
    chomp( $line );
    next if($line =~ /^\s*$/);
    push( @$array, $line );
  }
  
  # close input file
  close FILE;

}

#####################################################################################################
# subroutine to find median of an array

sub calcMedian{

	my( $array ) = @_;

	my @sorted = sort{ $a <=> $b } @$array;

	my $len = scalar(@sorted);
	my $i = (($len-1)/2);

	my $median = 0;

	if( ($len % 2) == 0 ){
		$median = $sorted[$i];
	}else{
		$median = (($sorted[$i] + $sorted[$i+1])/2);
	}

	return $median;

}

#####################################################################################################
# subroutine to find standard deviation of an array

sub calcStdev{

	my( $array, $mean ) = @_;

	my @devArr;

	my $stdev = 0;

	foreach my $val( @$array ){
		my $dev = ($val - $mean)**2;
		push( @devArr, $dev );
	}

	my $sum = 0;
	foreach my $val( @devArr ){
		$sum+=$val;
	}

	if( (scalar(@$array)-1)>0 ){
		my $temp = $sum/(scalar(@$array)-1);
		$stdev = sqrt($temp);
	}

	return $stdev;

}

#####################################################################################################
# subroutine to find minimum value of an array

sub calcMin{

	my( $array ) = @_;

	my @sorted = sort{ $a <=> $b } @$array;

	return shift(@sorted);

}

#####################################################################################################
# subroutine to find maximum value of an array

sub calcMax{

	my( $array ) = @_;

	my @sorted = sort{ $a <=> $b } @$array;

	return pop(@sorted);

}

#####################################################################################################
# subroutine to calculate mean of an array

sub calcMean{

	my( $array ) = @_;

	my $total = 0;
	my $count = scalar( @$array );

	foreach my $item( @$array ){
		$total+=$item;
	}
	my $mean = $total/$count;

	return $mean;

}

#####################################################################################################
