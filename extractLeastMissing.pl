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
getopts( 'hf:m:o:s:', \%opts );

# if -h flag is used, or if no command line arguments were specified, kill program and print help
if( $opts{h} ){
  &help;
  die "Exiting program because help flag was used.\n\n";
}

# parse the command line
my( $file, $map, $out, $samps ) = &parsecom( \%opts );

my @popmapLines;
my @missingLines;
my %popmap;
my %missing;

&filetoarray( $file, \@missingLines );
&filetoarray( $map, \@popmapLines );

foreach my $line( @popmapLines ){
	my @temp = split( /\s+/, $line );
	$popmap{$temp[0]}=$temp[1];
}

foreach my $line( @missingLines ){
	my @temp = split( /\s+/, $line );
	$missing{$popmap{$temp[0]}}{$temp[0]}=$temp[1];
}

open( OUT, '>', $out ) or die "Can't open $out: $!\n\n";

foreach my $pop( sort keys %missing ){
	#print $pop, "\n";
	my $counter=0;
	foreach my $ind( sort {$missing{$pop}{$a} <=> $missing{$pop}{$b} } keys %{$missing{$pop}} ){
		# this will probably fail if number of keys in %missing{$pop} < $samps
		if( $counter < $samps ){
			#print $ind, "\t", $missing{$pop}{$ind}, "\n";
			print OUT $ind, "\t", $popmap{$ind}, "\n";
			$counter++;
		}else{
			last;
		}
	}
}

close OUT;

#print Dumper( \%missing );

exit;

#####################################################################################################
############################################ Subroutines ############################################
#####################################################################################################

# subroutine to print help
sub help{
  
  print "\nextractLeastMissing.pl is a perl script developed by Steven Michael Mussmann\n\n";
  print "To report bugs send an email to mussmann\@email.uark.edu\n";
  print "When submitting bugs please include all input files, options used for the program, and all error messages that were printed to the screen\n\n";
  print "Program Options:\n";
  print "\t\t[ -f | -h | -m | -o | -s ]\n\n";
  print "\t-f:\tSpecify the name of the input file.\n";
  print "\t\tThis should be a tab-delimited file from my missingData.sh script.\n\n";
  print "\t-h:\tDisplay this help message.\n";
  print "\t\tThe program will die after the help message is displayed.\n\n";
  print "\t-m:\tSpecify input population map (tab delimited; format=sampleName<tab>populationName).\n\n";
  print "\t-o:\tSpecify output file name (Optional; default=retainedMap.txt).\n\n";
  print "\t-s:\tSpecify the number of samples per population to be retained. Samples with the least missing data will be kept (default=2).\n\n";
  
}

#####################################################################################################
# subroutine to parse the command line options

sub parsecom{ 
  
  my( $params ) =  @_;
  my %opts = %$params;
  
  # set default values for command line arguments
  my $file = $opts{f} || die "No input file specified (output of missingData.sh script).\n\n"; #used to specify input file name.
  my $map = $opts{m} || die "No input population map specified.\n\n"; #used to population map file name.
  my $out = $opts{o} || "retainedMap.txt"; #used to specify output file name.
  my $samps = $opts{s} || "2"; #used to specify number of individuals per population to retain in output.

  return( $file, $map, $out, $samps );

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
