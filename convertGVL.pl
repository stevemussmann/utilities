#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Std;
use Scalar::Util qw(looks_like_number);
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

my %hoa = (
	"Htr-GVL-025" => ["N","T","C"],
	"Htr-GVL-026" => ["N","G","A"],
	"Htr-GVL-001" => ["N","C","A"],
	"Htr-GVL-027" => ["N","A","G"],
	"Htr-GVL-028" => ["N","A","G"],
	"Htr-GVL-002" => ["N","C","T"],
	"Htr-GVL-003" => ["N","A","G"],
	"Htr-GVL-004" => ["N","A","G"],
	"Htr-GVL-005" => ["N","G","A"],
	"Htr-GVL-029" => ["N","G","A"],
	"Htr-GVL-030" => ["N","A","G"],
	"Htr-GVL-006" => ["N","G","A"],
	"Htr-GVL-031" => ["N","C","A"],
	"Htr-GVL-032" => ["N","T","C"],
	"Htr-GVL-007" => ["N","T","C"],
	"Htr-GVL-008" => ["N","A","G"],
	"Htr-GVL-009" => ["N","A","G"],
	"Htr-GVL-033" => ["N","C","A"],
	"Htr-GVL-010" => ["N","T","A"],
	"Htr-GVL-034" => ["N","C","T"],
	"Htr-GVL-035" => ["N","C","T"],
	"Htr-GVL-011" => ["N","T","G"],
	"Htr-GVL-036" => ["N","A","G"],
	"Htr-GVL-037" => ["N","C","A"],
	"Htr-GVL-012" => ["N","C","T"],
	"Htr-GVL-038" => ["N","G","A"],
	"Htr-GVL-039" => ["N","A","G"],
	"Htr-GVL-040" => ["N","G","A"],
	"Htr-GVL-013" => ["N","C","A"],
	"Htr-GVL-041" => ["N","A","G"],
	"Htr-GVL-042" => ["N","T","C"],
	"Htr-GVL-043" => ["N","A","G"],
	"Htr-GVL-044" => ["N","C","T"],
	"Htr-GVL-045" => ["N","C","T"],
	"Htr-GVL-046" => ["N","A","G"],
	"Htr-GVL-047" => ["N","C","G"],
	"Htr-GVL-048" => ["N","T","G"],
	"Htr-GVL-049" => ["N","G","T"],
	"Htr-GVL-050" => ["N","G","A"],
	"Htr-GVL-051" => ["N","C","T"],
	"Htr-GVL-052" => ["N","C","A"],
	"Htr-GVL-053" => ["N","C","A"],
	"Htr-GVL-014" => ["N","T","C"],
	"Htr-GVL-054" => ["N","C","T"],
	"Htr-GVL-055" => ["N","G","A"],
	"Htr-GVL-056" => ["N","G","C"],
	"Htr-GVL-015" => ["N","C","G"],
	"Htr-GVL-057" => ["N","T","C"],
	"Htr-GVL-058" => ["N","G","T"],
	"Htr-GVL-059" => ["N","G","T"],
	"Htr-GVL-060" => ["N","A","G"],
	"Htr-GVL-061" => ["N","A","G"],
	"Htr-GVL-062" => ["N","A","G"],
	"Htr-GVL-016" => ["N","C","T"],
	"Htr-GVL-017" => ["N","A","T"],
	"Htr-GVL-018" => ["N","T","C"],
	"Htr-GVL-063" => ["N","T","G"],
	"Htr-GVL-064" => ["N","A","G"],
	"Htr-GVL-065" => ["N","T","C"],
	"Htr-GVL-019" => ["N","T","G"],
	"Htr-GVL-066" => ["N","T","C"],
	"Htr-GVL-067" => ["N","T","C"],
	"Htr-GVL-068" => ["N","T","A"],
	"Htr-GVL-069" => ["N","C","A"],
	"Htr-GVL-020" => ["N","T","C"],
	"Htr-GVL-021" => ["N","G","T"],
	"Htr-GVL-070" => ["N","C","T"],
	"Htr-GVL-071" => ["N","A","C"],
	"Htr-GVL-072" => ["N","T","C"],
	"Htr-GVL-022" => ["N","A","T"],
	"Htr-GVL-073" => ["N","C","T"],
	"Htr-GVL-023" => ["N","T","A"],
	"Htr-GVL-024" => ["N","G","T"],
	"Htr-GVL-074" => ["N","A","C"],
	"Htr-GVL-075" => ["N","C","G"]
);

my %hash = (
	"Htr-GVL-025" => "Htr-GVL-A000003",
	"Htr-GVL-026" => "Htr-GVL-A000054",
	"Htr-GVL-001" => "Htr-GVL-A000078",
	"Htr-GVL-027" => "Htr-GVL-A000133",
	"Htr-GVL-028" => "Htr-GVL-A000144",
	"Htr-GVL-002" => "Htr-GVL-A000163",
	"Htr-GVL-003" => "Htr-GVL-A000195",
	"Htr-GVL-004" => "Htr-GVL-A000225",
	"Htr-GVL-005" => "Htr-GVL-A000314",
	"Htr-GVL-029" => "Htr-GVL-A000366",
	"Htr-GVL-030" => "Htr-GVL-A000374",
	"Htr-GVL-006" => "Htr-GVL-A000419",
	"Htr-GVL-031" => "Htr-GVL-A000431",
	"Htr-GVL-032" => "Htr-GVL-A000468",
	"Htr-GVL-007" => "Htr-GVL-A000492",
	"Htr-GVL-008" => "Htr-GVL-A000500",
	"Htr-GVL-009" => "Htr-GVL-A000505",
	"Htr-GVL-033" => "Htr-GVL-A000573",
	"Htr-GVL-010" => "Htr-GVL-A000612",
	"Htr-GVL-034" => "Htr-GVL-A000641",
	"Htr-GVL-035" => "Htr-GVL-A000646",
	"Htr-GVL-011" => "Htr-GVL-A000651",
	"Htr-GVL-036" => "Htr-GVL-A000668",
	"Htr-GVL-037" => "Htr-GVL-A000683",
	"Htr-GVL-012" => "Htr-GVL-A000714",
	"Htr-GVL-038" => "Htr-GVL-A000716",
	"Htr-GVL-039" => "Htr-GVL-A000789",
	"Htr-GVL-040" => "Htr-GVL-A000839",
	"Htr-GVL-013" => "Htr-GVL-A000850",
	"Htr-GVL-041" => "Htr-GVL-A000899",
	"Htr-GVL-042" => "Htr-GVL-A000903",
	"Htr-GVL-043" => "Htr-GVL-A000914",
	"Htr-GVL-044" => "Htr-GVL-A000988",
	"Htr-GVL-045" => "Htr-GVL-A001011",
	"Htr-GVL-046" => "Htr-GVL-A001014",
	"Htr-GVL-047" => "Htr-GVL-A001047",
	"Htr-GVL-048" => "Htr-GVL-A001103",
	"Htr-GVL-049" => "Htr-GVL-A001159",
	"Htr-GVL-050" => "Htr-GVL-A001186",
	"Htr-GVL-051" => "Htr-GVL-A001235",
	"Htr-GVL-052" => "Htr-GVL-A001274",
	"Htr-GVL-053" => "Htr-GVL-A001303",
	"Htr-GVL-014" => "Htr-GVL-A001430",
	"Htr-GVL-054" => "Htr-GVL-A001459",
	"Htr-GVL-055" => "Htr-GVL-A001460",
	"Htr-GVL-056" => "Htr-GVL-A001494",
	"Htr-GVL-015" => "Htr-GVL-A001499",
	"Htr-GVL-057" => "Htr-GVL-A001520",
	"Htr-GVL-058" => "Htr-GVL-A001590",
	"Htr-GVL-059" => "Htr-GVL-A001607",
	"Htr-GVL-060" => "Htr-GVL-A001676",
	"Htr-GVL-061" => "Htr-GVL-A001677",
	"Htr-GVL-062" => "Htr-GVL-A001696",
	"Htr-GVL-016" => "Htr-GVL-A001699",
	"Htr-GVL-017" => "Htr-GVL-A001701",
	"Htr-GVL-018" => "Htr-GVL-A001702",
	"Htr-GVL-063" => "Htr-GVL-A001734",
	"Htr-GVL-064" => "Htr-GVL-A001753",
	"Htr-GVL-065" => "Htr-GVL-A001799",
	"Htr-GVL-019" => "Htr-GVL-A001852",
	"Htr-GVL-066" => "Htr-GVL-A001918",
	"Htr-GVL-067" => "Htr-GVL-A001921",
	"Htr-GVL-068" => "Htr-GVL-A001925",
	"Htr-GVL-069" => "Htr-GVL-A001939",
	"Htr-GVL-020" => "Htr-GVL-A002071",
	"Htr-GVL-021" => "Htr-GVL-A002099",
	"Htr-GVL-070" => "Htr-GVL-A002107",
	"Htr-GVL-071" => "Htr-GVL-A002157",
	"Htr-GVL-072" => "Htr-GVL-A002159",
	"Htr-GVL-022" => "Htr-GVL-A002161",
	"Htr-GVL-073" => "Htr-GVL-A002165",
	"Htr-GVL-023" => "Htr-GVL-A002185",
	"Htr-GVL-024" => "Htr-GVL-A002206",
	"Htr-GVL-074" => "Htr-GVL-A002242",
	"Htr-GVL-075" => "Htr-GVL-A002270"
);

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

#my $file = "2022_gvl_genotypes.txt";
my @lines; # hold lines from input file

# read in file
&filetoarray( $file, \@lines );

# capture header from file
my $header = shift( @lines );
$header =~ s/\./\-/g; # make it match names
my @head = split( /\s+/, $header );

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

	for( my $i=1; $i<@temp; $i+=2 ){

		# get locus name for lookup
		my @temp2 = split( /_/, $head[$i] );
		my $locus = $temp2[0];

		# lookup alleles
		my @templocus;
		if( !looks_like_number($temp[$i]) ){
			print "Warning: value $temp[$i] for sample $temp[0], locus $locus is not a number.\n";
			push( @templocus, $hoa{$locus}[0] );
			push( @templocus, $hoa{$locus}[0] );
		}else{
			push( @templocus, $hoa{$locus}[$temp[$i]] );
			push( @templocus, $hoa{$locus}[$temp[$i+1]] );
		}
		my $newlocus = join( '', @templocus );
		$newlocus =~ s/NN/0/g;
		$dataHash{$temp[0]}{$hash{$locus}} = $newlocus;
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
  
  print "\nconvertGVL.pl is a perl script developed by Steven Michael Mussmann\n\n";
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
  my $out = $opts{o} || "GVLconvertedGenotypes.txt"; #used to specify output file name.

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
