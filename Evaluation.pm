package Evaluation;
use strict;
use warnings;

use Similarite;
use Requete;

sub evaluation {
	open( FQ, "<cacm/qrels.text" ) or die "open: $!";

	my ($line);
	my $reqCour      = 1;
	my @docPertinent = ();

	while ( defined( $line = <FQ> ) ) {
		if ( $line =~ /([0-9]+) ([0-9]+) 0 0/ ) {
			my $req = $1;
			my $doc = $2;
			if ( $reqCour == $req ) {
				#On mémorise les différents docs pertinents.
				push( @docPertinent, $doc );
			}else {
				print " requete: $reqCour \n";
				#evaluation des docs pertinents.
				my $requete    = Requete::getQuery($req);
				my $reqTraite  = Requete::traitementRequete($requete);
				my %HASH       = Similarite::simililarite($reqTraite);
				my $classement = 0;
				foreach my $key ( sort { $HASH{$b} <=> $HASH{$a} } keys %HASH ){
					my $score       = int( $HASH{$key} );
					my $nbpertinent = 0;
					foreach my $k (@docPertinent) {
						$nbpertinent++;
						if ( $k == $key ) {
							print " doc $k classé $classement.";
						}
					}
					$classement++;
				}
				#On passe au suivant.
				@docPertinent = ();
				push( @docPertinent, $doc );
				$reqCour = $req;
			}
		}
	}
	close(FQ);
}

1;
