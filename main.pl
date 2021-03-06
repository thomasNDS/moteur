
#!/usr/bin/perl -w

use strict;
use Vocabulaire;
use Similarite;
use Requete;
use DocumentIndexable;
use Corpus;
use Recherche;
use Index;
use Evaluation;

# perl main.pl TEXTE ma recherche
# perl main.pl EVALUATION
# perl main.pl DOC 451

my $nbArg = 2;
my $req   = "";
my $nbReq = 0;
while ( defined( $ARGV[$nbArg] ) ) {
	$req = $req . " " . $ARGV[$nbArg];
	$nbArg++;
}
if ( defined( $ARGV[0] ) ) {
	if ( defined( $ARGV[1] ) && $ARGV[0] eq "TEXTE" ) {
		$nbReq= $ARGV[1];
		Recherche::recherche($req,$nbReq);
	}
	else {
	  if ( $ARGV[0] eq "EVALUATION"){
		Evaluation::evaluation();
	  }else{
		if (defined( $ARGV[1] ) && $ARGV[0] eq "DOC"){
		  print "<dd><h2> Document $ARGV[1]:\n</h2></dd>";
		  print "<div style=\"width:60%;text-align:justify; margin-left:100px;\">";
		  my @mots =Corpus::trouverTexteIdColor( "fichiersGeneres/cacmSansXN", $ARGV[1] );
		  foreach my $word (@mots) {
		      print "$word ";
		  }
		  print "</div>";
		}
	  }
	}
}

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
