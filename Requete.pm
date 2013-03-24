package Requete;
use strict;
use warnings;

use DocumentIndexable;
use Corpus;
use Vocabulaire;

# Traitement pour indexer une requete et faire l'appariement.
# @param la requete en une ligne $.
# @return la requete indexée sur le ligne $.
sub traitementRequete {
	my ($requete) = @_;
	my $N = 3204;
	my ( @words, $word, %total );
	@words = split( /\W+/, $requete );

	my @trueWords = DocumentIndexable::supprimerMotCourant(@words);
	foreach $word (@trueWords) {
		$word =~ tr/A-Z/a-z/;    # Non sensible à la casse.
		$total{$word}++;
	}
	my $res = "";
	foreach $word ( sort keys %total ) {
		my $tf  = $total{$word};
		my $df  = Vocabulaire::getMotDansVoc($word);
		my $idf = log( $N / $tf );
		my $ct  = int( $df * $idf );
		$res = $res . "$word=$ct ";
	}
	return $res;
}

# renvoi la liste des requetes non pertinentes.
# @return une liste @.
sub getQueryNonPertinentes {
	open( FQ, "<cacm/qrels.text" ) or die "open: $!";
	my ( $line, @num );
	while ( defined( $line = <FQ> ) ) {
		if ( $line =~ /([0-9]+) ([0-9]+) 0 0/ ) {
			my $nb = $1;
			if ( !( "@num" =~ /$nb/ ) ) {
				push( @num, $nb );
			}
		}
	}
	close(FQ);
	return @num;
}

#genere le fichier queryNet netoyé.
sub genererQueryNetoyees {
	open( FO, "<cacm/query.text" ) or die "open: $!";
	open( FileS, ">fichiersGeneres/queryNet" )
	  or die "Erreur ouverture cacmSansXN.";
	my ( $text, $line, @num, $word );
	$text = 0;
	@num  = getQueryNonPertinentes();
	for my $nu (@num) {
		print "$nu ";
	}
	while ( defined( $line = <FO> ) ) {
		if ( $line =~ /.I ([0-9]+)/ ) {
			my $nb = $1;
			if ( "@num" =~ /$nb/ ) {
				print "yes $nb\n";
				$text = 1;
			}
		}
		else {
			if ( $line =~ /.N/ ) {    #  .N non pertinent.
				$text = 0;
			}
		}
		if ( $text == 1 && !( $line =~ /.W/ || $line =~ /.A/ ) ) {
			if ( !( $line =~ /.I/ || $line =~ /.W/ || $line =~ /.A/ ) ) {
				$line =~ tr/A-Z/a-z/;
			}
			print FileS $line;
		}
	}
	close(FO);
	close(FileS);
}

# renvoi une requete de query Netoyés
# @param le numéro de celle voulue.
# @return la query en $.
sub getQuery {
	my ($id) = @_;
	open( FQN, "<fichiersGeneres/queryNet" ) or die "open: $!";
	my ( $line, $numeroDoc );
	my $req = "";
	$numeroDoc = 0;
	while ( !( $numeroDoc == $id + 1 ) && defined( $line = <FQN> ) ) {
		if ( $line =~ /(.I +([0-9\.]+))/ ) {
			$numeroDoc = $2;
		}
		else {
			if ( $numeroDoc == $id) {
				#print $line;
				$req = $req . " " . $line;
			}
		}
	}
	close(FQN);
	return $req;
}

1;
