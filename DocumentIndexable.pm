package DocumentIndexable;
use strict;
use warnings;

# Transforme une ligne indexée en table de hashage mot/c.
# @param la ligne indexée.
# @return la table de hash.
sub indexVersHash {
	my ($index) = @_;
	my %hash;
	my @words = split( " ", $index );
	for my $word (@words) {
		if ( $word =~ /(\w+)=([0-9]*)/ ) {
			$hash{$1} = $2;
		}
	}
	return %hash;
}

# Supprime les mots les plus courants.
sub supprimerMotCourant {
	my ( $present, $line, @words, $word, @output );
	my (@motsANettoyer) = @_;
	open( F, "<cacm/common_words" ) or die "open: $!";
	@words = <F>;

	foreach $word (@motsANettoyer) {
		if ( "@words" =~ m/\Q$word\E/ ) {
			#  print "$word supprimer\n";
		}
		else {
			unshift( @output, $word );
		}
	}
	close(F);
	return @output;
}

1;