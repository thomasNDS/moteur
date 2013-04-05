package Similarite;

use warnings;
use strict;

use DocumentIndexable;
use Corpus;

# Lien documents/Requêtes.

#Calcule la norme d'un document.
#@param une ligne de l'index d'un document our requete.
#@return la norme de ce document ou requete.
sub calculerNormeLigne {
	my ($line) = @_;
	my $norme = 0;
	my @words = split( " ", $line );
	for my $word (@words) {
		if ( $word =~ /(\w+)=([0-9]*)/ ) {
			$norme = $norme + $2 * $2;
		}
	}
	$norme = int sqrt $norme;
	return $norme;
}

#Genere un fichier contenant l'ensemble des normes des caractéristiques des
#Documents.
sub genererNormeIndex {
	open( FINDEX, "<fichiersGeneres/index" )      or die "open: $!";
	open( FNORME, ">fichiersGeneres/normeIndex" ) or die "open: $!";
	my ( $line, $norme );

	while ( defined( $line = <FINDEX> ) ) {
		$norme = calculerNormeLigne($line);
		print FNORME "$norme\n";
	}
	close(FINDEX);
	close(FNORME);
}

# Calcule la similarité pour une requête.
# Pour i de 1 à N:
# 	| s[i] <-0
# 	Pour j de 1 à  à Nombre de caractéristiques associées à i:
# 		| Si le terme associé à c(x,j) apparait dans la requête Q
# 			| s[i] <- s[i] + c(ti,di) * c(ti,Q)'
# 	s[i] <- s[i] / (Normq * z[i])

# @param la requete $.
# @return hash doc/score %.
sub simililarite {
	my ($requete) = @_;
	my $NormReq   = calculerNormeLigne($requete);

	my %indexReq  = DocumentIndexable::indexVersHash($requete);
	my ( $line, $cR, $vR, $cD, $vD, %scoreDoc );
	my $numDoc = 1;
	my $score;
	open( FINDEX, "<fichiersGeneres/index" ) or die "open: $!";

	# pour chaque document:
	while ( defined( $line = <FINDEX> ) ) {
		$score = 0;

		# pour chaque mot du document:
		my $increment = 1;
		my %indexDoc  = DocumentIndexable::indexVersHash($line);
		while ( ( $cD, $vD ) = each(%indexDoc) ) {

			# pour chaque mot de la requete

			while ( ( $cR, $vR ) = each(%indexReq) ) {

				if ( $cR eq $cD ) {
					$increment++;
					$score = $score + $vR * $vD * $increment+0.1;
				}
			}
		}
		if ( $NormReq > 0 ) {
			my $normDoc = Corpus::getNormeDoc($numDoc);

			#print "doc:$normDoc </br>";
			if ( $normDoc > 0 ) {
				$score = $score / ( ( 1 / 10000 ) * ($NormReq) * $normDoc );
			}
			else { 
				$score = -1; 
			}
			if ( $score > 0 ) {
				$scoreDoc{$numDoc} = $score;
			}
		}
		$numDoc++;
	}

	close(FINDEX);
	return %scoreDoc;
}

1;
