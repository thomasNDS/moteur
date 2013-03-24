#!/usr/bin/perl -w

use strict;
use warnings;

use Vocabulaire;
use Similarite;
use Requete;
use DocumentIndexable;
use Corpus;
use Index;
use Evaluation;

sub testTraitementRequete {
	my $req =
	  Requete::traitementRequete("cacm for ever load big hello president 2000");
	my @words = split( " ", $req );
	for my $word (@words) {
		print "$word ";
	}

}

sub testSimilarite {
	my $req = Requete::traitementRequete(
"I'm interested in mechanisms for communicating between disjoint processes,
possibly, but not exclusively, in a distributed environment.  I would
rather see descriptions of complete mechanisms, with or without implementations,
as opposed to theoretical work on the abstract problem.  Remote procedure
calls and message-passing are examples of my interests."
	);

	my %HASH = Similarite::simililarite($req);
	trierHash(%HASH);

	#	afficherHash(%res);
}

sub testindexVersHash {
	my %res = DocumentIndexable::indexVersHash("cpt=121 coucou=8888 lol=3");
	my ( $c, $v );
	while ( ( $c, $v ) = each(%res) ) {
		print "Cle : $c, Valeur : $v\n";
	}
}

sub testgetNormeDoc {
	print Corpus::getNormeDoc(5);
}

sub testgetQuery {
	my $a = Requete::getQuery(2);
	print "req = $a";
}

print "start \n";
Evaluation::evaluation();
print "fin";
1;

