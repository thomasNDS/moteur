
#!/usr/bin/perl -w

use strict;
use Vocabulaire;
use Similarite;
use Requete;
use DocumentIndexable;
use Corpus;
use Recherche;

	my $nbArg = 0;
	my $req   = "";
	while ( defined( $ARGV[$nbArg] ) ) {
		$req = $req . " " . $ARGV[$nbArg];
		$nbArg++;
	}
	print "</br> <b>La requete:</b> $req</br>";
	Recherche::recherche($req);

#print "start \n";
#Requete::genererQueryNetoyees();
#tests::testSimilarite();
# calculerNormeLigne($requete);
# supprimerXN("cacm/cacm.all");
#Vocabulaire::vocabulaire("fichiersGeneres/cacmSansXN");

# Index::creationIndex("fichiersGeneres/cacmSansXN");
# Similarite::genererNormeIndex();
# print "\nresultat: $retour\n";

#print "\nterminate\n";
