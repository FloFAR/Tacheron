#!/bin/bash
# Programme tacheron

# Cette fonction va permettre "d'automatiser" la recherche des commandes à effectuer
function check_bool () {
#arg 1: heure actuelle
#arg 2: heure de la commande

# "tacheron" parce que Bash va interpréter le caratère * comme étant "tacheron"
if [[ "$2" = "tacheron" ]]
then
	echo true

elif [[ $2 == $1 ]]
then
	echo true

elif [[ $2 =~ [0-9]-[0-9]{1,2}$ ]]
then 
	for i in $( eval echo {$(echo $2 | awk -F- '{printf $1}')..$(echo $2 | awk -F- '{printf $2}')} )
	do
		if [ $i -eq $1 ]
		then
			echo true
		fi
	done

elif [[ $2 =~ [0-9], ]]
then
	declare -a liste=()
	a=$( echo $2 | awk -F, '{print NF}')
	for i in $( eval echo {1..$a} )
	do
		b=$( echo $2 | cut -d, -f$i )
		liste+=($b)
	done
	for i in ${liste[@]}
	do
		if [ $1 -eq $i ]
		then
			echo true
		fi
	done


elif [[ $2 =~ / ]]
then
	if [[ $2 =~ \*\/ ]]
	then
		declare -a val=()
		a=$( echo $2 | cut -d/ -f2 )
		for (( i=0; i<=59; i+=$a ))
		do
			val+=($i)
		done
		for i in ${val[*]}
		do
			if [[ $1 == $i ]]
			then
				echo true
				break
			fi
		done

	elif [[ $2 =~ -[0-9]*/ ]]
	then
		t=$( echo $2 | awk -F- '{printf $1}' )
		u=$( echo $2 | awk -F- '{printf $2}' | cut -d/ -f1 )
		a=$( echo $2 | cut -d/ -f2 )
		for (( i=$t; i<=$u; i+=$a ))
		do
			if [ $i -eq $1 ]
			then
				echo true
			fi
		done
	fi

elif [[ $2 =~ [0-9]\~ ]]
then

	declare -a liste1=()
	declare -a liste2=()
	for i in $( eval echo {$(echo $2 | awk -F- '{print $1}')..$(echo $2 | awk -F- '{printf $2}' | awk -F~ '{print $1}')})
	do
		liste1+=($i)
	done
	c=$( echo $2 | awk -F- '{print $2}' | awk -F~ '{print $2}')
	liste2+=($c)
	d=$( echo $2 | awk -F~ '{print NF}' )
	if [[ $d -ge 3 ]]
	then
		for (( i=3; i<=$d; i++ ))
		do
			e=$( echo $2 | awk -F- '{print $2}' | cut -d~ -f$i )
			liste2+=($e)
		done
	fi
	
	for i in ${liste2[*]}
	do
		liste1=(${liste1[@]/$i})
	done
	for i in ${liste1[*]}
	do
			if [ $i -eq $1 ]
			then
				echo true
			fi
	done

fi

}

# Cette fonction va permettre "d'automatiser" la recherche des commandes à effectuer sur les secondes
function check_bool_sec () {
#arg 1: seconde actuelle
#arg 2: seconde de la commande

if [[ "$2" = "tacheron" ]]
then
	echo true

elif [[ $2 = $(($1 / 15)) ]]
then
	echo true

elif [[ $2 =~ [0-9]-[0-9] ]]
then 
	for i in $( eval echo {$(echo $2 | awk -F- '{printf $1}')..$(echo $2 | awk -F- '{printf $2}')} )
	do
		if [ $i -eq $(($1 / 15)) ]
		then
			echo true
		fi
	done

elif [[ $2 =~ [0-9], ]]
then
	declare -a liste=()
	a=$( echo $1 | awk -F, '{print NF}')
	for i in $( eval echo {1..$a} )
	do
		b=$( echo $1 | cut -d, -f$i )
		liste+=($b)
	done
	for i in ${liste[@]}
	do
		if [ $i -eq $(($1 / 15)) ]
		then
			echo true
		fi
	done


elif [[ $2 =~ / ]]
then
	if [[ $2 =~ \*\/ ]]
	then	
		declare -a val=()
		a=$( echo $2 | cut -d/ -f2 )
		for (( i=0; i<=59; i+=$a ))
		do
			val+=($i)
		done
		for i in ${val[*]}
		do
			if [[ $i -eq $(($1 / 15)) ]]
			then
				echo true
				break
			fi
		done

	elif [[ $2 =~ -[0-9]*/ ]]
	then
		t=$( echo $2 | awk -F- '{printf $1}' )
		u=$( echo $2 | awk -F- '{printf $2}' | cut -d/ -f1 )
		a=$( echo $2 | cut -d/ -f2 )
		for (( i=$t; i<=$u; i+=$a ))
		do
			if [ $i -eq $(($1 / 15)) ]
			then
				echo true
			fi
		done
	fi

elif [[ $2 =~ [0-9]~ ]]
then

	declare -a liste1=()
	declare -a liste2=()
	for i in $( eval echo {$(echo $2 | awk -F- '{print $1}')..$(echo $2 | awk -F- '{printf $2}' | awk -F~ '{print $1}')})
	do
		liste1+=($i)
	done
	c=$( echo $2 | awk -F- '{print $2}' | awk -F~ '{print $2}')
	liste2+=($c)
	d=$( echo $2 | awk -F~ '{print NF}' )
	if [[ $d -ge 3 ]]
	then
		for (( i=3; i<=$d; i++ ))
		do
			e=$( echo $2 | awk -F- '{print $2}' | cut -d~ -f$i )
			liste2+=($e)
		done
	fi
	
	for i in ${liste2[*]}
	do
		liste1=(${liste1[@]/$i})
	done
	for i in ${liste1[*]}
	do
			if [ $i -eq $(($1 / 15)) ]
			then
				echo true
			fi
	done

fi

}

# Si une erreur apparait, le set -e va permettre de stopper le script

set -e
#A chaque fois que le script va se finir, on le relance en reinitialisant l'heure actuelle
while true
do
	# Déclaration de tableaux qui vont nous servir pour la suite
	declare -a commande=()
	declare -a seconde=()
	declare -a minute=()
	declare -a heure=()
	declare -a jour_mois=()
	declare -a jour_semaine=()
	declare -a mois=()
	declare -a date_actuelle=()
	set $(date)

		case $1 in
			lundi)  date_actuelle+=(1);;
			mardi)  date_actuelle+=(2);;
			mercredi)  date_actuelle+=(3);;
			jeudi)  date_actuelle+=(4);;
			vendredi)  date_actuelle+=(5);;
			samedi)  date_actuelle+=(6);;
			dimanche)  date_actuelle+=(0);;
		esac

		date_actuelle+=($2)

		case $3 in
			janvier)  date_actuelle+=(1);;
			février)  date_actuelle+=(2);;
			mars)  date_actuelle+=(3);;
			avril)  date_actuelle+=(4);;
			mai)  date_actuelle+=(5);;
			juin)  date_actuelle+=(6);;
			juillet)  date_actuelle+=(7);;
			août)  date_actuelle+=(8);;
			septembre)  date_actuelle+=(9);;
			octobre)  date_actuelle+=(10);;
			novembre)  date_actuelle+=(11);;
			décembre)  date_actuelle+=(12);;
		esac

		date_actuelle+=($( date +"%H"))
		date_actuelle+=($( date +"%M"))
		date_actuelle+=($( date +"%S"))

	# On cree un fichier listecommande qui va contenir toutes les commandes a verifier

	sudo tee /etc/listecommande < /etc/tacherontab
	for ligne in $(cat /etc/tacheron.allow)
	do
		if [[ -f /etc/tacheron/tacherontab$ligne ]]
		then
			fichier=$( find /etc/tacheron/tacherontab$ligne)
			sudo tee -a /etc/listecommande < $fichier
		fi
	done

	# On lit chaque commande

	while read ligne
	do
		# Creation de Tab_Intermediaire pour permettre de stocker les differentes donnees
    		Tab_Intermediaire=($(echo "$ligne"))
    		seconde[${#seconde[@]}]=${Tab_Intermediaire[0]};
    		minute[${#minute[@]}]=${Tab_Intermediaire[1]}; 
    		heure[${#heure[@]}]=${Tab_Intermediaire[2]};
    		jour_mois[${#jour_mois[@]}]=${Tab_Intermediaire[3]};
    		mois[${#mois[@]}]=${Tab_Intermediaire[4]};
    		jour_semaine[${#jour_semaine[@]}]=${Tab_Intermediaire[5]};
		commande[${#commande[@]}]=$(IFS=" "; echo "${Tab_Intermediaire[*]:6}";IFS=" \t\n")
	done < /etc/listecommande
	#cat /etc/listecommande
	# On va boucler sur le nombre total de commandes que l'on a stocké
	for (( j=0; j < ${#commande[*]}; j++ ))
	do
		#echo "$j"
		#echo ${minute[j]}
		#echo ${commande[*]}
		tableau_bool=()
		tableau_bool+=(false)
		tableau_bool+=(false)
		tableau_bool+=(false)
		tableau_bool+=(false)
		tableau_bool+=(false)
		tableau_bool+=(false)
		# 1er element: seconde
		# 2e element: minute
		# 3e element: heure
		# 4e element: numéro jour
		# 5e element: jour
		# 6e element: mois

		# On va vérifier si chaque élément(sec, min, heure, jour,...) correspond à l'heure actuelle
		#echo ${commande[j]}

		if [[ $(check_bool_sec ${date_actuelle[5]} ${seconde[j]}) == true ]]
		then
			#echo "seconde"
			tableau_bool[0]=true
		fi


		if [[ $(check_bool ${date_actuelle[4]} ${minute[j]}) == true ]]
		then
			#echo "minute"
			tableau_bool[1]=true
		fi

		if [[ $(check_bool ${date_actuelle[3]} ${heure[j]}) == true ]]
		then
			#echo "heure"
			tableau_bool[2]=true
		fi

		if [[ $(check_bool ${date_actuelle[1]} ${jour_mois[j]}) == true ]]
		then
			#echo "jour mois"
			tableau_bool[3]=true
		fi

		if [[ $(check_bool ${date_actuelle[0]} ${jour_semaine[j]}) == true ]]
		then
			#echo "jour semaine"
			tableau_bool[4]=true
		fi

		if [[ $(check_bool ${date_actuelle[2]} ${mois[j]}) == true ]]
		then
			#echo "mois"
			tableau_bool[5]=true
		fi

		
		#echo ${tableau_bool[*]}
		if [[ "${tableau_bool[0]}" == "true" && "${tableau_bool[1]}" == "true" && "${tableau_bool[2]}" == "true" && "${tableau_bool[3]}" == "true" && "${tableau_bool[4]}" == "true" && "${tableau_bool[5]}" == "true" ]]
		then
			# eval va permettre de convertir commande[j] en commande executable
			eval ${commande[j]}
			echo "On a utilisé la commande ${commande[j]} le $(date +%x) à $(date +%X)" | sudo tee -a /var/log/tacheron 
		fi
	done
	echo "-----------------------------"
done

