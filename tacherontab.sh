#!/bin/bash
# Programmation du service Tacheron

# 3 choix :
	# -l : affiche le fichier tacherontab de l'utilisateur situé dans le répertoire /etc/tacheron/
	# -r : efface le fichier tacherontab
	# -e : édite ou crée le fichier

# arg1 : -u
# arg2 : l'utilisateur
# arg3 : commande à suivre

if [[ $1 == -u ]]
then

	if [[ $3 == -l ]]
	then
			cat /etc/tacheron/tacherontab$2

	elif [[ $3 == -r ]]
	then
			sudo rm /etc/tacheron/tacherontab$2

	elif [[ $3 == -e ]]
	then

			mktemp /tmp/tmp.projetLO14
			vi /tmp/tmp.projetLO14
			sudo tee -a /etc/tacheron/tacherontab$2 <  /tmp/tmp.projetLO14
			sudo rm /tmp/tmp.projetLO14
			
	else
		echo "Les seules options possibles sont -l, -r ou -e"
	fi

else
	echo "Le premier paramètre n'est pas -u"
fi

