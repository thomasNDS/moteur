package Index;

use warnings;
use strict;

use DocumentIndexable;
use Corpus;
use Vocabulaire;

#	_INDEX___________________________________
#	|1: 1=c(t1) i=c(ti) j= c(tj)			|
#	|										|
#	|num doc: score							|
#	_________________________________________
#
# @param le fichier.
# @param l'id.
sub creationIndex {
	my ( $filename, $id ) = @_;
	my $N = 3204;
	open( FOI,    "<$filename" )             or die "open: $!";
	open( FINDEX, ">fichiersGeneres/index" ) or die "open: $!";
	my ( $line, @words, $word, $numeroDoc, %total );
	$numeroDoc = 0;

	while ( defined( $line = <FOI> ) ) {
		if ( $line =~ /(.I +([0123456789\.]+))/ ) {
			$numeroDoc = $2;
			print "\n $numeroDoc  ";
			print FINDEX "$numeroDoc: ";    #Saut de ligne !
			                                # On obtient le numéro.
			if ( $numeroDoc > 1 ) {
				foreach $word ( sort keys %total ) {

					my $tf = $total{$word};

					#df: nombre de doc ou le terme apparait.
					my $df = Vocabulaire::getMotDansVoc($word);
					my $idf;
					if ( $df > 0 ) {
						$idf = log( $N / $df );
					}
					else {
						$idf = 0.1;
					}
					if ( $idf < 1 ) { $idf = 0.1; }
					my $ct = int( $tf * $idf );
					print FINDEX "$word=$ct ";

					#print "$word=$ct ";
				}
			}
			print FINDEX "\n";
			%total = ();
		}
		else {

			# On affiche le contenu si pas de balise.
			if ( !( $line =~ /\.[TXNBAW]+/ ) ) {
				$words[ $#words + 1 ] = $line;

				# uniquement caractère alphanumérique.
				@words = split( /\W+/, $line );
				my @trueWords = DocumentIndexable::supprimerMotCourant(@words);

				foreach $word (@trueWords) {
					$word =~ tr/A-Z/a-z/;    # Non sensible à la casse.
					$total{$word}++;
				}
			}
		}
	}
	close(FOI);
	close(FINDEX);
}

1;
