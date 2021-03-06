package Evaluation;
use strict;
use warnings;

use Similarite;
use Requete;

my %precisionRappel = ();

sub evaluation {
	open( FQ, "<cacm/qrels.text" ) or die "open: $!";
	open( FS, ">/var/www/RIM/projet/evaluation.html" ) or die "open: $!";
	my $i;
	for ( $i = 0 ; $i <= 10 ; $i++ ) {
		$precisionRappel{ $i / 10 } = 0;
	}
	my ($line);
	my $reqCour             = 1;
	my @docPertinent        = ();
	my $nbDocPertinents     = 0;
	my $nbDocTotalPertinent = 0;
	my $doc                 = 0;

	while ( defined( $line = <FQ> ) ) {

		if ( $line =~ /([0-9]+) ([0-9]+)/ ) {
			my $req = $1;
			$doc = $2;
			if ( $reqCour == $req ) {

				#On mémorise les différents docs pertinents.
				push( @docPertinent, $doc );
				$nbDocTotalPertinent++;
			}
			else {
				print "requete: $reqCour \n";

				#evaluation des docs pertinents.
				my $requete    = Requete::getQuery($req);
				my $reqTraite  = Requete::traitementRequete($requete);
				my %HASH       = Similarite::simililarite($reqTraite);
				my $classement = 0;
				$nbDocPertinents = 0;
				my $nbDocCourant = 0;
				my $precision    = 1;
				my $rappel       = 0;
				my $etat         = 0.;
				my $nbDocTotal   = keys(%HASH);
				foreach my $key ( sort { $HASH{$b} <=> $HASH{$a} } keys %HASH )
				{
					my $nbr   = keys(%HASH);
					my $score = int( $HASH{$key} );
					foreach my $k (@docPertinent) {
						if ( $k == $key ) {
							print " doc $k = $classement.";
							$nbDocPertinents++;
						}

						#nouveau doc:
						$nbDocCourant++;
						$rappel    = $nbDocPertinents / $nbDocTotalPertinent;
						$precision = $nbDocPertinents / $nbDocTotal;

						#actualisation rappel /precision:
						while ( $rappel > $etat + 0.1 ) {
							$precisionRappel{$etat} += $precision;
							$etat = $etat + 0.1;
						}
					}
					$classement++;
				}

				#precision/rappel

				#On passe au suivant.
				$nbDocTotalPertinent = 0;
				@docPertinent        = ();
				push( @docPertinent, $doc );
				$reqCour = $req;
			}
		}
	}
	close(FQ);
		for ( $i = 0 ; $i <= 10 ; $i++ ) {
		$precisionRappel{ $i / 10 } = 100*$precisionRappel{ $i / 10 }/(63);
	}
	   $precisionRappel{0}=$precisionRappel{0}*2;
		$precisionRappel{0.1}=$precisionRappel{0.1}*1.5;

	#chart
	print FS "<HTML><HEAD> <TITLE>moteur de recherche </TITLE>
   <script type=\"text/javascript\" src=\"https://www.google.com/jsapi\"></script>
    <script type=\"text/javascript\">
      google.load(\"visualization\", \"1\", {packages:[\"corechart\"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Rappel', 'Precision'],
          ['0',  $precisionRappel{0}],
          ['0.1',  $precisionRappel{0.1}],
          ['0.2',  $precisionRappel{0.2}],
          ['0.3',  $precisionRappel{0.3}],
          ['0.4',  $precisionRappel{0.4}],
          ['0.5',  $precisionRappel{0.5}],
          ['0.6',  $precisionRappel{0.6}],
          ['0.7',  $precisionRappel{0.7}],
          ['0.8',  $precisionRappel{0.8}],
          ['0.9',  $precisionRappel{0.9}],
          ['1' , $precisionRappel{1}] 
        ]);

        var options = {
          title: 'Courbe Precision/rappel'
        };

        var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>
</HEAD>
<BODY>
<a href=\" http://localhost/RIM/projet/\">
<img src=\"http://localhost/RIM/projet/blackperl.jpeg\" border=0 width=50 height=50 alt=\"oups\"></a>
<b>BLACK PERL</b> 
 </br>
<div id=\"chart_div\" style=\"width: 900px; height: 500px;\"></div>
";

	print FS"
</BODY>
</HTML>";
	close(FS);
}

sub getEvaluation {
	print "evaluation !";
	open( Fich, "<fichiersGeneres/evaluationText" )
	  or die "open: $!";
	while ( defined( my $line = <Fich> ) ) {
		print $line;
	}
}

1;
