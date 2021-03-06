package Corpus;

use warnings;
use strict;

# Pré traitement des données.

# Supprime les parties .X et .N d'un document.
# @param le fichier a trier.
sub supprimerXN {
	my ($filename) = @_;
	open( FileO, "<$filename" )  or die "open: $!";
	open( FileS, ">fichiersGeneres/cacmSansXN" ) or die "Erreur ouverture cacmSansXN.";
	my ( $text, $line, @words, $word );
	$text = 0;

	while ( defined( $line = <FileO> ) ) {
		if (   $line =~ /.T/
			|| $line =~ /.A/
			|| $line =~ /.W/
			|| $line =~ /.B/
			|| $line =~ /.I/ )
		{
			$text = 1;
		}
		else {
			if ( $line =~ /.X/ || $line =~ /.N/|| $line =~ /.C/ || $line =~ /.K/) {  
			  # .X, .N,C,K non pertinent.
				$text = 0;
			}
		}
		if ( $text == 1 ) {
			print FileS $line;
			#print  $line;
		}
	}
	close(FileO);
	close(FileS);
}



# calcule le nombre de document d'un corpus.
# @param le document.
# @return le nombre de documents.
sub getNombreDeDocs {
	my ($filename) = @_;
	open( FSEARCH, "<$filename" ) or die "open: $!";
	my ( $line, @words, $word, $nbDoc );
	$nbDoc = 0;
	while ( defined( $line = <FSEARCH> ) ) {
		if ( $line =~ /(.I +([0123456789\.]+))/ ) {
			$nbDoc = $2;
			# On obtient le numéro.
		}
	}
	close(FSEARCH);
	return $nbDoc;
}

# Renvoi le texte associé à l'id avec décor HTML.
# @param1 document.
# @param2 Id
# @return tableau du texte associé.
sub trouverTexteIdColor {
	my ( $filename, $id ) = @_;
	open( FSEARCH, "<$filename" ) or die "open: $!";
	my ( $line, @words, $word, $numeroDoc );
	$numeroDoc = 0;
	my $auteur= 0;
	while ( !( $numeroDoc == $id + 1 ) && defined( $line = <FSEARCH> ) ) {
		# On obtient le numéro.
		if ( $line =~ /(.I +([0123456789\.]+))/ ) {
			$numeroDoc = $2;
		}
		if ($line =~ /\.A /) {$auteur=1;}
		if ($line =~ /\.[TXNBW]+/) {$auteur=0;}
		else {
			# On affiche le contenu si pas de balise.
			if ( $numeroDoc == $id && !( $line =~ /\.[TXNBAIW]+/ ) ) {
			    if ($auteur==1){
			        $words[ $#words + 1 ] = "<b></br> $line</b>";
			    }else{
				$words[ $#words + 1 ] = $line;
			    }
			}
		}
	}
	close(FSEARCH);
	return @words;
}


# Renvoi le texte associé à l'id.
# @param1 document.
# @param2 Id
# @return tableau du texte associé.
sub trouverTexteId {
	my ( $filename, $id ) = @_;
	open( FSEARCH, "<$filename" ) or die "open: $!";
	my ( $line, @words, $word, $numeroDoc );
	$numeroDoc = 0;
	while ( !( $numeroDoc == $id + 1 ) && defined( $line = <FSEARCH> ) ) {
		if ( $line =~ /(.I +([0123456789\.]+))/ ) {
			$numeroDoc = $2;

			# On obtient le numéro.
		}
		else {

			# On affiche le contenu si pas de balise.
			if ( $numeroDoc == $id && !( $line =~ /\.[TXNBAW]+/ ) ) {
				$words[ $#words + 1 ] = $line;
			}
		}
	}
	close(FSEARCH);
	return @words;
}

# Compte le nombre de ligne d'un corpus.
# @param le fichier
sub nbLigneFich {
	my ( $line, @words, $word );
	my ($filename) = @_;
	my $numberLines = 0;
	open( FILE, "<$filename" );
	while ( my $ligne = <FILE> ) {
		$numberLines++;
	}
	close(FILE);
	return $numberLines;
}

#renvoi la norme du ieme document.
#@param le numéro du document.
#@return la ligne.
sub getNormeDoc {
	my ($ligneVoulue) = @_;
	my $numLine = 1;
	my ($line);
	my $norme = 0;
	open( FNORME, "<fichiersGeneres/normeIndex" ) or die "open: $!";
	while ( $numLine <= $ligneVoulue && defined( $line = <FNORME> ) ) {

		if ( $numLine == $ligneVoulue ) {
			if ( $line =~ /([0-9]+)/ ) {
				$norme = $1;
			}
		}
		$numLine++;
	}
	return $norme;
	close(FNORME);
}

1;
