#!/usr/bin/perl -w
use strict;







#   readFASTA_numeric_id
#################################################################
#################################################################
#################################################################
sub readFASTA_numeric_id{

	my $in = shift(@_);
	open(FILE, $in);
	my @data = <FILE>;
	close FILE;

	my %seq_data;
	my %h_count;
	
	my $stu = join '', @data;
	my @seqs = split />/, $stu;
	shift(@seqs);
	my $id_num = 0;
	foreach my $stuff(@seqs){
		#print "$stuff\n\n";
		my @sh = split '\n', $stuff;
		chomp(@sh);
		my $header = shift(@sh);
		my $sequence = join '', @sh;
		$sequence =~ s/\W//g;
		$sequence = uc($sequence);
		
		$seq_data{$id_num} = $sequence;
		$h_count{$header}++;
		$id_num++;
	}
	
	my @turds = grep {$h_count{$_} > 1} keys %h_count;
	
	if ($#turds >=0){
	
		print "it seems you have some duplicate headers in your file\n";
		print "These will be treated as the same sequence,\n";
		print "and if multiple copies of the same chromosome are present in the fasta file\n";
		print "they will at least need to be named differently\n";
		print "maybe you should check your file to make sure all individuals have differing headers\n";
	
	}
	return %seq_data;

}1;

#################################################################
#################################################################
#################################################################



#   readFASTA
#################################################################
#################################################################
#################################################################
sub readFASTA{

	my $in = shift(@_);
	open(FILE, $in);
	my @data = <FILE>;
	close FILE;

	my %seq_data;
	my %h_count;
	
	my $stu = join '', @data;
	my @seqs = split />/, $stu;
	shift(@seqs);
	foreach my $stuff(@seqs){
		#print "$stuff\n\n";
		my @sh = split '\n', $stuff;
		chomp(@sh);
		my $header = shift(@sh);
		my $sequence = join '', @sh;
		$sequence = uc($sequence);
		
		$seq_data{$header} = $sequence;
		$h_count{$header}++;

	}
	
	my @turds = grep {$h_count{$_} > 1} keys %h_count;
	
	if ($#turds >=0){
	
		print "it seems you have some duplicate headers in your file\n";
		print "These will be treated as the same sequence,\n";
		print "and if multiple copies of the same chromosome are present in the fasta file\n";
		print "they will at least need to be named differently\n";
		print "maybe you should check your file to make sure all individuals have differing headers\n";
	
	}
	return %seq_data;

}1;

#################################################################
#################################################################
#################################################################




#      clean_sequences
#################################################################
#################################################################
#################################################################

sub clean_sequences{
	my $sh_ref = shift;
	my %seq_data = %$sh_ref;

	foreach my $header (keys %seq_data){
	
		my $sequence = $seq_data{$header};
		
		#clean shit out
		$sequence =~ tr/[B|D-F|H-S|U-Z]/-/;
		$sequence =~ s/\W/-/g;
	
		$seq_data{$header} = $sequence;
	
	}

	return %seq_data;

}1;
#################################################################
#################################################################
#################################################################



