#!/usr/bin/perl -w
use strict;


########################################################################################
# Wyatt Clark
#
#  ./encode.pl infile outfile K
#
# Given a FASTA file of sequences (infile) encodes them into vectors of counts of K mer words
# (I believe we call this N other places) 
#
# NOTE: Standard Amino Acid characters only
#  
# Output is in sparse format, where each row in the output file is 3 values, 
#	1st = row number
#	2nd = column number
#	3rd = value
#
########################################################################################


# add required packages
############################################
require "SeqUtil.pl";
############################################



#get options (no error checking)
############################################
my $infile = shift;
#my $outfile = shift;
my $K = shift;
############################################



# create codebook
############################################
my %code_book;
my @aas = ("A", "R", "N", "D", "C", "Q", "E", "G", "H", "I", "L", "K", "M", "F", "P", "S", "T", "W", "Y", "V");
my $num_characters = $#aas + 1;
map $code_book{$aas[$_]} = $_, (0..$#aas);


#print map "$code_book{$_}\t$_\n", keys(%code_book);
############################################




# load sequences
############################################
my %seq_data = readFASTA_numeric_id($infile);
my @headers = keys(%seq_data);
my $num_seqs = $#headers + 1;
############################################



#open outfile (no error checking)
############################################
open(FILE, ">SK_"."$K".".txt");
############################################


my %big_code_book;
my %mapping;
my $n_codes = 1;
#encode
############################################
foreach my $i(0..$#headers){
	my $real_index = $i +1;

	my %local_counts;
	my $seq = $seq_data{$i};

	#print "$seq\n";
	foreach my $start (0..length($seq) - $K ){
		
		my $code = 0;
		my $sub_str = substr($seq, $start, $K);
		
		foreach my $j(0..$K-1){
			my $character = substr($sub_str, $j, 1);
			#print "$character\n";
			
			if (!exists($code_book{$character})){
			
				print "error, $character not found in codebook $real_index\n";
				exit;
			}
			
			$code += ($code_book{$character} * ($num_characters ** $j));
		
		}
		$code = $code + 1;
		
		if (!exists($mapping{$code})){
			$mapping{$code} = $n_codes;
			$n_codes++;
		}
		
		
		#print "$sub_str\t$code\n";
		$local_counts{$code}++;
		$big_code_book{$sub_str} = $code;
		
	
	}
	
	
	####################################
	print FILE map "$real_index\t$mapping{$_}\t$local_counts{$_}\n", keys %local_counts;
 	####################################


}



#close outfile
############################################
close FILE;
############################################

print "\n\nPRINTING BIG CODEBOOK\n\n";
open(FILE, ">codebook_K"."$K".".txt");

print FILE map "$_\t$big_code_book{$_}\n", keys(%big_code_book);
close(FILE);

# print kept columns so you can reduce matrix size if desired
open(F, ">kept_columns_"."$K".".txt");
print F map "$big_code_book{$_}\n", keys(%big_code_book);
close(F);



