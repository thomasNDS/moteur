package Recherche;

use strict;
use warnings;

use Similarite;
use Requete;
use Corpus;

my @req       = ();
my $nbRequete = 0;

#Affiche des resultats de requetes sous forme HTML
#@param le hash doc/score %.
sub trierHash {
	print "<blockquote>";
	my (%HASH) = @_;
	my $nbr = keys(%HASH);
	my $key;
	my $nbRep   = 0;
	my $nbLigne = 3;
	if ( $nbr <= 0 ) { print "<h5>Aucun resultat trouve.</h5>"; }
	else {if ( $nbr >= 50 ){ $nbr=$nbr+2;}
		print "<h4>$nbr resulats trouves sur 3204 presents.</h4>";
	}
	foreach $key ( sort { $HASH{$b} <=> $HASH{$a} } keys %HASH ) {
		$nbRep++;
		if ( $nbRep > $nbRequete ) {
			exit;
		}
		my $score   = int( $HASH{$key} );
		my $truekey = $key - 1;
		print "<span style=\"margin-left:30px;\">";
		print "<form id=\"test$truekey\" action= \"http://localhost/cgi-bin/RIM/search.cgi\">
                 <input type=hidden name=NUM value=  $truekey /></form>
                 <a href='#' onclick='document.getElementById(\"test$truekey\").submit()'>";
		print "</br><font color=\"blue\"><b>document:</b>$truekey  ";
		print "<b>Score:</b>$score</font> </br></a></span>";
		print "<dd>";
		my @mots =
		  Corpus::trouverTexteId( "fichiersGeneres/cacmSansXN", $truekey );
		my $cpt = 0;

		while ( defined $mots[$cpt] && $cpt <= $nbLigne ) {
			my $mot = $mots[$cpt];
			foreach my $word (@req) {
				$mot =~ s/$word/<b>$word<\/b>/i;
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
print "</blockquote>";
}

#Lance une recherche et affiche le résultat HTML
#@param la requete en $.
sub recherche {
	my ( $requete, $nbReq ) = @_;
	$nbRequete = $nbReq;
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
