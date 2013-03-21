package Recherche;

use strict;
use warnings;

use Similarite;
use Requete;
use Corpus;

my @req = ();

#Affiche des resusltats de requetes sous forme HTML
#@param le hash doc/score %.
sub trierHash {
	my (%HASH) = @_;
	my $key;
	my $nbRep   = 0;
	my $nbLigne = 3;
	foreach $key ( sort { $HASH{$b} <=> $HASH{$a} } keys %HASH ) {
		$nbRep++;
		if ( $nbRep > 20 ) {
			exit;
		}
		my $score = int( $HASH{$key} );
		print "<span style=\"margin-left:30px;\">";
		print "</br><font color=\"blue\"><b>document:</b>$key  ";
		print "<b>Score:</b>$score</font> </br></span>";
		print "<dd>";
		my @mots = Corpus::trouverTexteId( "fichiersGeneres/cacmSansXN", $key );
		my $cpt  = 0;

		while ( defined $mots[$cpt] && $cpt <= $nbLigne ) {
			my $mot = $mots[$cpt];
			foreach my $word (@req) {
				$mot =~ s/$word/<b>$word<\/b>/;
			}
			if ( $cpt < $nbLigne ) {
				print "$mot</br>";
			}
			else {
				if ( $cpt == $nbLigne ) {
					print "$mot...</br>";
				}
			}
			$cpt++;
		}
		print "</dd>";
	}
}

#Lance une recherche et affiche le résultat HTML
#@param la requete en $.
sub recherche {
	my ($requete) = @_;
	my $reqTraite = Requete::traitementRequete($requete);
	my %HASH      = Similarite::simililarite($reqTraite);
	@req = split( /\W+/, $requete );
	trierHash(%HASH);
}

sub afficherHash {
	my (%res) = @_;
	my ( $c, $v );
	while ( ( $c, $v ) = each(%res) ) {
		print "Cle : $c, Valeur : $v\n";
	}
}

1;
