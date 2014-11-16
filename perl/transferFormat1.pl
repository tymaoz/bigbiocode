# parse output of balstall
##################################################################################
# perl transferFormatX.pl Bisoncontigs_allBetscaffolds.blastn LuScaffolds091010.fa > output#
##################################################################################

use strict;
use FileHandle;
use Data::Dumper;

my ($blastout,$fastaSeq) = @ARGV;
my $fh = new FileHandle;
my (%match, %seq);
open($fh,$fastaSeq) or die("Cannot open seq file\n");
my @temp = <$fh>;
close($fh);
chomp(@temp);
%seq = @temp;
open($fh, $blastout) or die("Cannot open output of blast\n");
while(<$fh>) {
   chomp;
   if(/^\#/) {next;}
   my @t = split(/\t/);   
   my $hit = $t[0]."\t".$t[1]."\t".$t[3]."\t".$t[6]."\t".$t[7]."\t".$t[8]."\t".$t[9]."\t".$t[10];
   print $hit."\t";
   my $seq1 = extractSeq($seq{">$t[1]"},$t[8],$t[9]);
   if($t[8]<$t[9]) {
       print $seq1."\n";
   }
   else { my $seq2 = reveComp($seq1); print $seq2."\n"; }
}


sub extractSeq {
  my ($seq, $st, $ed) = @_;
  my @temp = split(//,$seq);
  my ($i,$j, $out);
# test-expression ? if-true-expression : if-false-expression
  my @t= ($st,$ed);
  @t = sort {$a<=>$b} @t;
  $i = $t[0]; $j = $t[1];
  for(;$i<$j;$i++) { 
     $out .= $temp[$i];
  }
  $out;
}



sub reveComp {
   my ($in) = @_;
   $in =~ s/A/B/g;
   $in =~ s/T/A/g;
   $in =~ s/G/F/g;
   $in =~ s/C/G/g;
   my @seq = split(//, $in);
   @seq = reverse @seq;
#my $n = @seq; print "seq length is ".$n."\n";
   my $temp = join('', @seq);
   $temp =~ s/B/T/g;
   $temp =~ s/F/C/g;
   $temp;
}


