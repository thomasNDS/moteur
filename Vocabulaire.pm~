package Vocabulaire;

use warnings;
use strict;
use DocumentIndexable;

# Crée le vocabulaire.

# Segmente le texte et forme le vocabulaire.
# @param le fichier à lire.
sub vocabulaire {
	my ($filename) = @_;
	open( FILE, "<$filename" ) or die "open: $!";
	my ( $line, @words, $word, %total );
	my $nouveauDoc = 0;
	my %finalWords= ();
	while ( defined( $line = <FILE> ) ) {
		if ( $line =~ /\.I [0-9]+/ ) {
			#Pour chaque document on actualise.
			foreach $word (keys %finalWords) {
				$total{$word}++;
				print "$word $total{$word} \n";
			}
			%finalWords =();
		}
		if ( !( $line =~ /\.[TAWBIKC] / ) ) {

			# uniquement caractère alphanumérique.
			@words = split( /\W+/, $line );
			my @trueWords = DocumentIndexable::supprimerMotCourant(@words);
			foreach $word (@trueWords) {
				$word =~ tr/A-Z/a-z/;    #Non sensible à la casse.
				$finalWords{$word}++;
			}
		}
	}
	close(FILE);
	open( FV, ">fichiersGeneres/vocabulaire" );
	foreach $word ( sort keys %total ) {
		print FV "$word $total{$word} \n";
	}
	close(FV);
}


# Trouve un mot et renvoi son nombre d'occurences dans le vocabulaire.
# @param le mot cherché.
# @return le nombre d'occurences.
sub getMotDansVoc {
	my ($mot) = @_;
	open( FVOC, "<fichiersGeneres/vocabulaire" )
	  or die "Erreur ouverture vocabulaire.";
	my ( $line, @words, $res );
	$res = 0;
	while ( defined( $line = <FVOC> ) ) {
		if ( $line =~ $mot ) {
			if ( $line =~ / ([0-9]+)/ ) {
				if ( $1 > $res ) {
					$res = $1;
				}
			}
		}
	}
	close(FVOC);
	return $res;
}

1;
