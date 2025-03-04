#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Std;
#use Data::Dumper;

# kill program and print help if no command line arguments were given
if( scalar( @ARGV ) == 0 ){
	&help;
	die "Exiting program because no command line options were used.\n\n";
}

# take command line arguments
my %opts;
getopts( 'hf:r:', \%opts );

# if -h option is used, print help and kill program
if( $opts{h} ){
	&help;
	die "Exiting program because help flag was used.\n\n";
}

# parse the command line
my( $genome, $renz ) = &parsecom( \%opts );

my %hash;

open( FILE, $genome ) or die "Can't open $genome: $!\n\n";

my $current = "";

while( my $line = <FILE> ){
	chomp( $line );
	if( $line =~ /^>/ ){
		my @temp = split( /\s+/, $line );
		$temp[0] =~ s/^>//g;
		$current = $temp[0];
	}else{
		$hash{$current} .= $line;
	}
}

close FILE;

my $total = 0; # counter to hold total number of restriction cut sites

print("Counting restriction cut sites for sequence $renz.\n");
foreach my $chrom( sort keys %hash ){
	my @count = $hash{$chrom} =~ /\Q$renz/g; # count restriction cut sites by chromosome
	$total+=scalar(@count); # add restriction cut sites to total
}

print "Restriction sites = ", $total, ".\n";

#print Dumper( \%hash );

exit;

#####################################################################################################
############################################ Subroutines ############################################
#####################################################################################################

# subroutine to print help
sub help{

  print "\ncountRestrictionCutSites.pl program options:\n";
  print "\t\t[ -f | -h | -r ]\n\n";
  print "\t-f:\tSpecify the name of the input reference genome file in fasta format.\n\n";
  print "\t-h:\tDisplay this help message.\n";
  print "\t\tThe program will die after the help message is displayed.\n\n";
  print "\t-r:\tSpecify the restriction cut site sequence (default = CCTGCAGG).\n\n";

}

#####################################################################################################
# subroutine to parse the command line options

sub parsecom{

  my( $params ) =  @_;
  my %opts = %$params;

  # set default values for command line arguments
  my $genome = $opts{f} || die "No reference genome file specified.\n\n"; #used to specify input genome.
  my $renz = $opts{r} || "CCTGCAGG"; #used to specify restriction cut site sequence. Default = SbfI.

  return( $genome, $renz );

}

#####################################################################################################
