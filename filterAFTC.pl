#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Std;
#use Scalar::Util qw(looks_like_number);
use Data::Dumper;


# kill program and print help if no command line arguments were given
if( scalar( @ARGV ) == 0 ){
  &help;
  die "Exiting program because no command line options were used.\n\n";
}

# take command line arguments
my %opts;
getopts( 'hf:o:', \%opts );

# if -h flag is used, or if no command line arguments were specified, kill program and print help
if( $opts{h} ){
  &help;
  die "Exiting program because help flag was used.\n\n";
}

# parse the command line
my( $file, $out ) = &parsecom( \%opts );

my @order = ("Htr-GVL-A000003",
	"Htr-GVL-A000054",
	"Htr-GVL-A000078",
	"Htr-GVL-A000133",
	"Htr-GVL-A000163",
	"Htr-GVL-A000314",
	"Htr-GVL-A000366",
	"Htr-GVL-A000374",
	"Htr-GVL-A000419",
	"Htr-GVL-A000431",
	"Htr-GVL-A000468",
	"Htr-GVL-A000492",
	"Htr-GVL-A000500",
	"Htr-GVL-A000505",
	"Htr-GVL-A000646",
	"Htr-GVL-A000651",
	"Htr-GVL-A000668",
	"Htr-GVL-A000683",
	"Htr-GVL-A000714",
	"Htr-GVL-A000716",
	"Htr-GVL-A000789",
	"Htr-GVL-A000839",
	"Htr-GVL-A000850",
	"Htr-GVL-A000903",
	"Htr-GVL-A000914",
	"Htr-GVL-A000988",
	"Htr-GVL-A001011",
	"Htr-GVL-A001014",
	"Htr-GVL-A001047",
	"Htr-GVL-A001186",
	"Htr-GVL-A001235",
	"Htr-GVL-A001303",
	"Htr-GVL-A001430",
	"Htr-GVL-A001459",
	"Htr-GVL-A001460",
	"Htr-GVL-A001494",
	"Htr-GVL-A001520",
	"Htr-GVL-A001590",
	"Htr-GVL-A001676",
	"Htr-GVL-A001677",
	"Htr-GVL-A001696",
	"Htr-GVL-A001699",
	"Htr-GVL-A001701",
	"Htr-GVL-A001702",
	"Htr-GVL-A001734",
	"Htr-GVL-A001852",
	"Htr-GVL-A001918",
	"Htr-GVL-A001921",
	"Htr-GVL-A001925",
	"Htr-GVL-A001939",
	"Htr-GVL-A002071",
	"Htr-GVL-A002099",
	"Htr-GVL-A002107",
	"Htr-GVL-A002157",
	"Htr-GVL-A002159",
	"Htr-GVL-A002161",
	"Htr-GVL-A002185",
	"Htr-GVL-A002206",
	"Htr-GVL-A002242",
	"Htr-GVL-A002270");

my @lines; # hold lines from input file

# read in file
&filetoarray( $file, \@lines );

# capture header from file
my $header = shift( @lines );
my @head = split( /\t/, $header );

# make new header for only loci that will be printed out
my @newhead;
push( @newhead, "sample" );
foreach my $locus( @order ){
	push( @newhead, $locus );
}
my $newheader = join( "\t", @newhead );

my %dataHash; #hash of hashes; key1 = individual; key2 = locus; value = genotype

foreach my $line( @lines ){
	my @temp = split( /\t/, $line );

	for( my $i=1; $i<@temp; $i++ ){
		$dataHash{$temp[0]}{$head[$i]} = $temp[$i];
	}
}

open( OUT, '>', $out ) or die "Can't open $out: $!\n\n";
print OUT $newheader, "\n";
foreach my $ind( sort keys %dataHash ){
	print OUT $ind;
	foreach my $locus( @order ){
		if( exists($dataHash{$ind}{$locus}) ){
			print OUT "\t", $dataHash{$ind}{$locus};
#		}else{
#			print "\t", "no";
		}
	}
	print OUT "\n";
}
close OUT;

#print Dumper(\@head);
#print Dumper(\%dataHash);

exit;

#####################################################################################################
############################################ Subroutines ############################################
#####################################################################################################

# subroutine to print help
sub help{
  
  print "\nfilterAFTC.pl is a perl script developed by Steven Michael Mussmann\n\n";
  print "To report bugs send an email to mussmann\@email.uark.edu\n";
  print "When submitting bugs please include all input files, options used for the program, and all error messages that were printed to the screen\n\n";
  print "Program Options:\n";
  print "\t\t[ -h | -f | -o ]\n\n";
  print "\t-h:\tDisplay this help message.\n";
  print "\t\tThe program will die after the help message is displayed.\n\n";
  print "\t-f:\tSpecify the name of the input file (tab-delimited format).\n\n";
  print "\t-o:\tSpecify output file (Optional).\n\n";
  
}

#####################################################################################################
# subroutine to parse the command line options

sub parsecom{ 
  
  my( $params ) =  @_;
  my %opts = %$params;
  
  # set default values for command line arguments
  my $file = $opts{f} || die "No input file specified.\n\n"; #used to specify input file name.
  my $out = $opts{o} || "AFTCfilteredGenotypes.txt"; #used to specify output file name.

  return( $file, $out );

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
		#print $line, "\n";
		push( @$array, $line );
	}

	#foreach my $thing( @$array ){
	#	print $thing, "\n";
	#}

	# close input file
	close FILE;

}

#####################################################################################################
